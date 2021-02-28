//
//  ClickerViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/17/21.
//

import UIKit

class ClickerViewController: UIViewController {

    @IBOutlet weak var totalIncome: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var upgradesButton: UIButton!
    @IBOutlet weak var clickerButton: UIButton!
    
    // M1: Stamina defaults to 5 when view loads
//    int stamina = 5
    // M1: save user's income
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: display user's saved income, stamina
        
        
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        // Go to profile view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let profileViewController =  storyboard.instantiateViewController(identifier: "profileViewController") as? ProfileViewController else {
            assertionFailure("Couldn't find Profile VC")
            return
        }
        
        // Push to stack because we want users to be able to go back to clicker view
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    @IBAction func upgradesButtonPressed(_ sender: Any) {
        // Go to upgrades view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let upgradesViewController =  storyboard.instantiateViewController(identifier: "upgradesViewController") as? UpgradesViewController else {
            assertionFailure("Couldn't find Upgrades VC")
            return
        }
        
        // Push to stack because we want users to be able to go back to clicker view
        self.navigationController?.pushViewController(upgradesViewController, animated: true)
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
    
    // TODO: clicker functionality
    @IBAction func cowClicked(_ sender: Any) {
    }
    
    // TODO: update stamina bar
//    func updateStamina {
//
//    }

}
