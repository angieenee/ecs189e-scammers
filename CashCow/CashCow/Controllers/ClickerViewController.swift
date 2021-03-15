//
//  ClickerViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/17/21.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class ClickerViewController: UIViewController {
    var user: User?
    var staminaTimer: Timer?
    var saveTimer: Timer?
    var passiveTimer: Timer?
    var coins = ImgSeqContainer()
    
    var timeWhenBackgrounded: NSDate?
    
    var progressUpdateAfterUpgrade: Float?
    
    @IBOutlet weak var totalIncome: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var upgradesButton: UIButton!
    @IBOutlet weak var clickerButton: UIButton!
    @IBOutlet weak var popupButton: UIButton!
    @IBOutlet weak var staminaBar: UIProgressView!
    @IBOutlet weak var coinPopUp: UIImageView!
    
    @IBOutlet weak var plusMinusSignLabel: UILabel!
    @IBOutlet weak var balanceStaminaChangeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plusMinusSignLabel.text = nil
        balanceStaminaChangeLabel.text = nil

        let coinsImgNames = ["CoinSpin_CashCow", "CoinSpin_Dollar", "CoinSpin_Moo"]
        self.coins = ImgSeqContainer(imgNames: coinsImgNames)
        
        let userRef = Database.database().reference(withPath: "users")
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }
        userRef.child(uid).observe(.value, with: { snapshot in
            if let data = snapshot.value as? [String: Any] {
                self.user?.load(data) {
                    self.totalIncome.text = self.user?.money?.getBalance()
                    print("USER STAMINA!!! \(self.user?.stamina ?? 1.0)")
                    self.staminaBar.progress = self.user?.stamina ?? 1.0
                }
            }
        })
        
        // FOR DEMO PURPOSES
        self.coinPopUp.isHidden = true
        
        self.staminaTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.reloadStamina), userInfo: nil, repeats: true)
        self.saveTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.saveData), userInfo: nil, repeats: true)
        
        self.passiveTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.generatePassiveIncome), userInfo: nil, repeats: true)
        /*
        self.popupTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
            timer in
                self.showPopUp()
        }*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopPassiveTimer), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(resumePassiveTimer), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // Update staminaBar.progress if it's not nil
        self.staminaBar.progress += self.progressUpdateAfterUpgrade ?? 0.0
        
        self.progressUpdateAfterUpgrade = 0.0
    }
    
    @objc func generatePassiveIncome() {
        let passive = self.user?.money?.moneyPassive ?? ["_" : 0, "A": 0]
        self.user?.money?.addBalance(passive)
        
        self.totalIncome.text = user?.money?.getBalance()
        
        self.plusMinusSignLabel.text = "+"
        self.balanceStaminaChangeLabel.text = self.user?.money?.getMoneyPassive()
    }
    
    
    @objc func stopPassiveTimer() {
        self.passiveTimer?.invalidate()
        self.user?.stamina = 1.0
        self.user?.save() {
            self.timeWhenBackgrounded = NSDate()
        }
       
    }
    
    func updateBalanceOnPassiveIncome(_ seconds: Int) {
        for _ in 1...seconds {
            self.user?.money?.addBalance(self.user?.money?.moneyPassive ?? ["_" : 0, "A": 0])
        }
        
        guard let currBalance =  self.user?.money?.balance else {
            return
        }
        self.totalIncome.text = self.user?.money?.formatMoney(currBalance)
        
        self.plusMinusSignLabel.text = "+"
        self.balanceStaminaChangeLabel.text = self.user?.money?.getMoneyPassive()
    }
        
    @objc func resumePassiveTimer() {
        guard var difference = self.timeWhenBackgrounded?.timeIntervalSinceNow else {return}
        difference = abs(difference)
        
        self.updateBalanceOnPassiveIncome(Int(difference))
        
        self.passiveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.generatePassiveIncome), userInfo: nil, repeats: true)
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        // Go to profile view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let profileViewController =  storyboard.instantiateViewController(identifier: "profileViewController") as? ProfileViewController else {
            assertionFailure("Couldn't find Profile VC")
            return
        }
        
        profileViewController.user = self.user
        
        // Push to stack because we want users to be able to go back to clicker view
        let viewControllers = [profileViewController, self]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func upgradesButtonPressed(_ sender: Any) {
        // Go to upgrades view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let upgradesViewController =  storyboard.instantiateViewController(identifier: "upgradesViewController") as? UpgradesViewController else {
            assertionFailure("Couldn't find Upgrades VC")
            return
        }
        
        upgradesViewController.user = self.user
        
        // Push to stack because we want users to be able to go back to clicker view
        let viewControllers = [upgradesViewController, self]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func stocksButtonPressed() {
        // Go to stocks view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let stocksViewController =  storyboard.instantiateViewController(identifier: "stocksViewController") as? StocksViewController else {
            assertionFailure("Couldn't find Stocks VC")
            return
        }
        
        stocksViewController.user = self.user
        
        // Push to stack because we want users to be able to go back to clicker view
        let viewControllers = [stocksViewController, self]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButtonPressed() {
        // Save user data, then logout
        self.user?.save() {
            // FB Logout
            let loginManager = LoginManager()
            
            if let _ = AccessToken.current {
                loginManager.logOut()
            }
            
            GIDSignIn.sharedInstance()?.signOut()
            
            // Sign out from Firebase
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                print ("Error signing out from Firebase: %@", error)
            }
            
            // Go back to login view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let loginViewController =  storyboard.instantiateViewController(identifier: "loginViewController") as? LoginViewController else {
                assertionFailure("Couldn't find Login VC")
                return
            }
            
            // Only have login view on stack so user can't go back
            let viewControllers = [loginViewController, self]
            self.navigationController?.setViewControllers(viewControllers, animated: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cowClicked(_ sender: Any) {
        // Update user balance and display
        if self.staminaBar.progress > 0 {
            self.totalIncome.text = self.user?.money?.click()
            self.subtractStamina(amount: 0.01)
            
            self.plusMinusSignLabel.text = "+"
            self.balanceStaminaChangeLabel.text = self.user?.money?.getMoneyClick()
            
            coinPopUp.animationImages = self.coins.imageSequences[Int.random(in: 0...self.coins.imageSequences.count-1)]
            coinPopUp.animationDuration = 1
            coinPopUp.animationRepeatCount = 1
            coinPopUp.image = coinPopUp.animationImages?.first
            coinPopUp.startAnimating()
        }
    }

    @IBAction func popupButtonPressed(_ sender: Any) {
        print("It's decision time!")
        //showPopUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let popUpViewController =  storyboard.instantiateViewController(identifier: "popUpViewController") as? PopUpViewController else {
            assertionFailure("Couldn't find VC")
            return
        }
        // Not dismissable
        popUpViewController.user = self.user
        popUpViewController.isModalInPresentation = true
        self.present(popUpViewController, animated: true)
    }
    
    // Stamina bar methods
    @objc func reloadStamina() {
        if (self.user?.stamina ?? 1) < 1 {
            self.staminaBar.progress += 0.03
            self.user?.stamina = (self.user?.stamina ?? 1) + 0.03
        } else {
            self.staminaBar.progress = 1.0
            self.user?.stamina = 1.0
        }
    }
    
    func subtractStamina(amount: Float) {
        self.staminaBar.progress -= amount
        self.user?.stamina = (self.user?.stamina ?? 1) - amount
    }
    
    @objc func saveData() {
        self.user?.save() {
            print("User data saved")
        }
    }
    
    func showPopUp() {
        // For the time being, this alert will be hard-coded
        let alert = UIAlertController(title: "Dinner Dash", message: "Hungry from the clicking? It’s time to refuel!", preferredStyle: .alert)
        let actionA = UIAlertAction(title: "MooDash Delivery +5A passive", style: .default) {
            (action) in print(action)
            self.user?.money?.moneyPassive = self.user?.money?.add(self.user?.money?.moneyPassive ?? ["_": 0], ["_": 0, "A": 5])
        }
        let actionB = UIAlertAction(title: "Cook At Home +5A clicker", style: .default) {
            (action) in print(action)
            self.user?.money?.moneyClick = self.user?.money?.add(self.user?.money?.moneyClick ?? ["_": 0], ["_": 0, "A": 5]) ?? ["_": 0]
        }
        
        // add to alert
        alert.addAction(actionA)
        alert.addAction(actionB)
        present(alert, animated: true, completion: nil)
    }
}
