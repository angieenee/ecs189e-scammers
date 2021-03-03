//
//  ClickerViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/17/21.
//

import UIKit

class ClickerViewController: UIViewController {
    var user: User?
    var staminaTimer: Timer?
    var coins = ImgSeqContainer()

    @IBOutlet weak var totalIncome: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
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
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        // Go to settings view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let settingsViewController =  storyboard.instantiateViewController(identifier: "settingsViewController") as? SettingsViewController else {
            assertionFailure("Couldn't find Settings VC")
            return
        }
        
        // Push to stack because we want users to be able to go back to clicker view
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @IBAction func cowClicked(_ sender: Any) {
        // Update user balance and display
        if self.staminaBar.progress > 0 {
            self.totalIncome.text = self.user?.money?.click()
            self.subtractStamina(amount: 0.01)
            
            coinPopUp.animationImages = self.coins.imageSequences[Int.random(in: 0...self.coins.imageSequences.count-1)]
            print(coinPopUp.animationImages ?? "uh oh stinky no animation images.")
            coinPopUp.animationDuration = 1
            coinPopUp.animationRepeatCount = 1
            coinPopUp.image = coinPopUp.animationImages?.first
            coinPopUp.startAnimating()
        }
    }

    // Stamina bar methods
    @objc func reloadStamina() {
        self.staminaBar.progress += 0.05
        print("Stamina added")
    }
    
    func subtractStamina(amount: Float) {
        self.staminaBar.progress -= amount
    }
}
