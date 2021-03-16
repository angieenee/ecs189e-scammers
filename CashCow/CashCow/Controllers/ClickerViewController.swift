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

protocol ViewControllerTransitionListener: class {
    func decisionPopupDismissed()
}

class ViewControllerTransitionMediator {
    weak var delegate: ViewControllerTransitionListener?
    
    func sendDecisionPopupDismissed(_ popupDiscussed: Bool) {
        print("DECISION POPUP DISMISSED")
        delegate?.decisionPopupDismissed()
    }
}

class ClickerViewController: UIViewController, ViewControllerTransitionListener {
    var ref = Database.database().reference(withPath: "decisions")
    var user: User?
    var staminaTimer: Timer?
    var saveTimer: Timer?
    var passiveTimer: Timer?
    var decisionPopupTimer: Timer?
    var coins = ImgSeqContainer()
    
    // List of popup options
    var decisions: [Decision] = []
    
    // Reference for when user exits the app to calculate passive income when re-entering
    var timeWhenBackgrounded: NSDate?
    
    @IBOutlet weak var totalIncome: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var upgradesButton: UIButton!
    @IBOutlet weak var clickerButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var staminaBar: UIProgressView!
    @IBOutlet weak var coinPopUp: UIImageView!
    @IBOutlet weak var balanceStaminaChangeLabel: UILabel!
    
    let viewControllerTransitionListener = ViewControllerTransitionMediator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        balanceStaminaChangeLabel.isHidden = true

        let coinsImgNames = ["CoinSpin_CashCow", "CoinSpin_Dollar", "CoinSpin_Moo"]
        self.coins = ImgSeqContainer(imgNames: coinsImgNames)
        
        viewControllerTransitionListener.delegate = self
        
        // Load user data from DB
        let userRef = Database.database().reference(withPath: "users")
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }
        userRef.child(uid).observe(.value, with: { snapshot in
            if let data = snapshot.value as? [String: Any] {
                self.user?.load(data) {
                    self.totalIncome.text = self.user?.money?.getBalance()
                    self.staminaBar.progress = self.user?.stamina ?? 1.0
                }
            }
        })
        
        // Load decisions data
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let vals = snapshot.value as? [[String: Any]] {
                let encoder = JSONDecoder()
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: vals)
                    self.decisions = try encoder.decode([Decision].self, from: jsonData)
                } catch {
                    self.decisions = []
                }
            }
        })
        
        // FOR DEMO PURPOSES
        self.coinPopUp.isHidden = true
        
        // Set up timers
        self.staminaTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.reloadStamina), userInfo: nil, repeats: true)
        self.saveTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.saveData), userInfo: nil, repeats: true)
        self.passiveTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.generatePassiveIncome), userInfo: nil, repeats: true)
        // TODO: CHANGE IT BACK TO 60 AFTER FINISH DEBUGGING
        self.decisionPopupTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {
            timer in
                print("***DECISION POPUP")
                self.showDecisionPopUp()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopPassiveTimer), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumePassiveTimer), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // Update staminaBar.progress if it's not nil
        self.staminaBar.progress = self.user?.stamina ?? 0.0
    }
    
    // Add passive income to total user balance and animate the change
    @objc func generatePassiveIncome() {
        let passive = self.user?.money?.moneyPassive ?? ["_" : 0, "A": 0]
        self.user?.money?.addBalance(passive)
        
        self.totalIncome.text = user?.money?.getBalance()
        
        // Trigger balance change animation async
        if let change = self.user?.money?.moneyPassive {
            self.showBalanceChange(amount: change, plus: true)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async {
                self.balanceStaminaChangeLabel.isHidden = true
            }
        }
    }
    
    // Stop timer for adding passive income
    @objc func stopPassiveTimer() {
        self.passiveTimer?.invalidate()
        self.user?.stamina = 1.0
        self.user?.save() {
            self.timeWhenBackgrounded = NSDate()
        }
    }
    
    // Add total passive income from when timer was stopped last
    func updateBalanceOnPassiveIncome(_ seconds: Int) {
        for _ in 1...seconds {
            self.user?.money?.addBalance(self.user?.money?.moneyPassive ?? ["_" : 0, "A": 0])
        }
        
        guard let currBalance =  self.user?.money?.balance else {
            return
        }
        self.totalIncome.text = self.user?.money?.formatMoney(currBalance)
    }
        
    // Start timer for adding passive income
    @objc func resumePassiveTimer() {
        guard var difference = self.timeWhenBackgrounded?.timeIntervalSinceNow else {return}
        difference = abs(difference)
        
        self.updateBalanceOnPassiveIncome(Int(difference))
        
        self.passiveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.generatePassiveIncome), userInfo: nil, repeats: true)
    }
    
    // Go to profile view
    @IBAction func profileButtonPressed(_ sender: Any) {
        // Go to profile view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let profileViewController =  storyboard.instantiateViewController(identifier: "profileViewController") as? ProfileViewController else {
            assertionFailure("Couldn't find Profile VC")
            return
        }
        
        profileViewController.user = self.user
        
        // Push self to stack because to allow animate in opposite direction
        let viewControllers = [profileViewController, self]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Go to upgrades view
    @IBAction func upgradesButtonPressed(_ sender: Any) {
        // Go to upgrades view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let upgradesViewController =  storyboard.instantiateViewController(identifier: "upgradesViewController") as? UpgradesViewController else {
            assertionFailure("Couldn't find Upgrades VC")
            return
        }
        
        upgradesViewController.user = self.user
        
        // Push self to stack because to allow animate in opposite direction
        let viewControllers = [upgradesViewController, self]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Go to stocks view
    @IBAction func stocksButtonPressed() {
        // Go to stocks view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let stocksViewController =  storyboard.instantiateViewController(identifier: "stocksViewController") as? StocksViewController else {
            assertionFailure("Couldn't find Stocks VC")
            return
        }
        
        stocksViewController.user = self.user
        
        // Push self to stack because to allow animate in opposite direction
        let viewControllers = [stocksViewController, self]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Go back to login view
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
            
            // Push self to stack because to allow animate in opposite direction
            let viewControllers = [loginViewController, self]
            self.navigationController?.setViewControllers(viewControllers, animated: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Reset game for current user
    @IBAction func resetButtonPressed() {
        self.user?.money = Mooooney.init()
        self.user?.stocks = nil
        self.user?.stocksOwned = []
        self.user?.upgrades = [:]
        self.user?.stamina = 1.0
        self.user?.save {
            print("User reset successfully")
        }
    }
    
    // Cow button clicked - money per click added to balance and animate the change
    @IBAction func cowClicked(_ sender: Any) {
        // Update user balance and display
        if self.staminaBar.progress > 0 {
            self.totalIncome.text = self.user?.money?.click()
            self.subtractStamina(amount: 0.01)
            
            coinPopUp.animationImages = self.coins.imageSequences[Int.random(in: 0...self.coins.imageSequences.count-1)]
            coinPopUp.animationDuration = 1
            coinPopUp.animationRepeatCount = 1
            coinPopUp.image = coinPopUp.animationImages?.first
            coinPopUp.startAnimating()
            
            //Trigger balance change animation
            if let change = self.user?.money?.moneyClick {
                self.showBalanceChange(amount: change, plus: true)
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                Thread.sleep(forTimeInterval: 0.5)
                DispatchQueue.main.async {
                    self.balanceStaminaChangeLabel.isHidden = true
                }
            }
        }
    }

    @IBAction func infoButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let infoPopupController = storyboard.instantiateViewController(withIdentifier: "infoPopupViewController") as? InfoPopupViewController else {
            assertionFailure("couldn't find infoPopupViewController")
            return
        }
        
        // User not allowed to abstain from choice
        infoPopupController.isModalInPresentation = true
        
         self.present(infoPopupController, animated: true)
    }
    
    // Add stamina
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
    
    // Save user info to Firebase
    @objc func saveData() {
        self.user?.save() {
            print("User data saved")
        }
    }
    
    // Present popup to user
    func showDecisionPopUp() {
        self.decisionPopupTimer?.invalidate()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let popUpViewController =  storyboard.instantiateViewController(identifier: "popUpViewController") as? PopUpViewController else {
            assertionFailure("Couldn't find Popup VC")
            return
        }
        
        // Not dismissable
        popUpViewController.user = self.user
        popUpViewController.decisions = self.decisions
        popUpViewController.isModalInPresentation = true
        
        popUpViewController.viewControllerTransitionListener = self.viewControllerTransitionListener
        
        self.present(popUpViewController, animated: true)
    }
    
    // "Animation" for keep user updated on how their balance is changing
    func showBalanceChange(amount: [String: Int], plus: Bool) {
        self.balanceStaminaChangeLabel.isHidden = false
        let text = plus ? "+\(self.user?.money?.formatMoney(amount) ?? "0.000A")" : "-\(self.user?.money?.formatMoney(amount) ?? "0.000A")"
        self.balanceStaminaChangeLabel.text = text
    }
    
    func decisionPopupDismissed() {
        if !(self.decisions.isEmpty) {
            self.decisions.removeFirst(1)
        }
        
        if !(self.decisions.isEmpty) {
            // TODO: CHANGE IT BACK TO 60 AFTER FINISH DEBUGGING
            self.decisionPopupTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) {
                timer in
                    print("***DECISION POPUP from delegate")
                    self.showDecisionPopUp()
            }
        }
       
    }
}
