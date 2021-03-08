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

class ClickerViewController: UIViewController {
    var user: User?
    var staminaTimer: Timer?
    var saveTimer: Timer?
    var passiveTimer: Timer?
    var popupTimer: Timer?
    var coins = ImgSeqContainer()

    @IBOutlet weak var totalIncome: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var upgradesButton: UIButton!
    @IBOutlet weak var clickerButton: UIButton!
    @IBOutlet weak var staminaBar: UIProgressView!
    @IBOutlet weak var coinPopUp: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let coinsImgNames = ["CoinSpin_CashCow", "CoinSpin_Dollar", "CoinSpin_Moo"]
        self.coins = ImgSeqContainer(imgNames: coinsImgNames)
        
        self.totalIncome.text = user?.money?.getBalance()
        self.staminaBar.progress = 1
        
        self.staminaTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.reloadStamina), userInfo: nil, repeats: true)
        self.saveTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.saveData), userInfo: nil, repeats: true)
        
        self.passiveTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) {
            timer in
                print("Passive Timer fired!")
                self.user?.money?.addBalance(self.user?.money?.moneyPassive ?? ["_" : 0, "A": 0])
                print("AMT NOW AFTER ADDING PASSIVE INCOME")
                self.user?.money?.printAmt()
        }
        
        self.popupTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
            timer in
                self.showPopUp()
                print("Testing if alert will show up.")
        }
        
        // Detect whether the user exited the app
        // When user exits the app, fire stopPassiveTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(stopPassiveTimer), name: UIApplication.willResignActiveNotification, object: nil)
        
        // Detect whether the user opens the app
        // When user enters back into the app, fire resumePassiveTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(resumePassiveTimer), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func stopPassiveTimer() {
        print("App moved to background!")
        
        // Stop timer
        // Save current time in NSDate
//        self.passiveTimer?.invalidate()
        
    }
    
    @objc func resumePassiveTimer() {
        print("App moved back to foreground!")
        
        // Calculate the difference from the stored date to the current date
        // From the difference, calculate how much passive income is earned
        // Update the total income earned
        // Start timer
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
            assertionFailure("Couldn't find Upgrades VC")
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
            
            coinPopUp.animationImages = self.coins.imageSequences[Int.random(in: 0...self.coins.imageSequences.count-1)]
            //print(coinPopUp.animationImages ?? "uh oh stinky no animation images.")
            coinPopUp.animationDuration = 1
            coinPopUp.animationRepeatCount = 1
            coinPopUp.image = coinPopUp.animationImages?.first
            coinPopUp.startAnimating()
        }
    }

    // Stamina bar methods
    @objc func reloadStamina() {
        self.staminaBar.progress += 0.05
        //print("Stamina added")
    }
    
    func subtractStamina(amount: Float) {
        self.staminaBar.progress -= amount
    }
    
    @objc func saveData() {
        self.user?.save() {
            print("User data saved")
        }
    }
    
    func showPopUp() {
        let alert = UIAlertController(title: "ALERT! ALERT!!", message: "This is my first alert.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) {
            (action) in print(action)
        }
        
        // add to alert
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
}
