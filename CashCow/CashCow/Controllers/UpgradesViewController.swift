//
//  UpgradesViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/21/21.
//

import UIKit
import FontAwesome_swift

class UpgradesViewController: UIViewController {
    var user: User?
    
    @IBOutlet weak var backButton: UIButton!
    
    // Icon buttons
    @IBOutlet weak var coffeeIcon: UIButton!
    @IBOutlet weak var diningIcon: UIButton!
    @IBOutlet weak var sleepIcon: UIButton!
    
    @IBOutlet weak var briefcaseIcon: UIButton!
    @IBOutlet weak var computerIcon: UIButton!
    @IBOutlet weak var phoneIcon: UIButton!
    
    // Amount labels
    @IBOutlet weak var coffeeAmountLabel: UILabel!
    @IBOutlet weak var diningAmountLabel: UILabel!
    @IBOutlet weak var sleepAmountLabel: UILabel!
    @IBOutlet weak var briefcaseAmountLabel: UILabel!
    @IBOutlet weak var computerAmountLabel: UILabel!
    @IBOutlet weak var phoneAmountLabel: UILabel!
    
    // Progress bars
    @IBOutlet weak var coffeeProgressBar: UIProgressView!
    @IBOutlet weak var diningProgessBar: UIProgressView!
    @IBOutlet weak var sleepProgressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var amountsList = ["5a", "10a", "15a", "1b", "2b", "3b"]
        
        let amountLabelsList = [self.coffeeAmountLabel, self.diningAmountLabel, self.sleepAmountLabel, self.briefcaseAmountLabel, self.computerAmountLabel, self.phoneAmountLabel]
                
        // Prepend $ to all consts using map
        amountsList = amountsList.map{"$" + $0}
                
        // Set amount labels to respective consts
        for (amountLabel, amounts) in zip(amountLabelsList, amountsList) {
            amountLabel?.text = amounts
        }
        
        // Initialize FontAwesome icons
        coffeeIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        coffeeIcon.setTitle(String.fontAwesomeIcon(name: .coffee), for: .normal)
        
        diningIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        diningIcon.setTitle(String.fontAwesomeIcon(name: .utensils), for: .normal)
        
        sleepIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        sleepIcon.setTitle(String.fontAwesomeIcon(name: .moon), for: .normal)
        
        briefcaseIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        briefcaseIcon.setTitle(String.fontAwesomeIcon(name: .briefcase), for: .normal)
        
        computerIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        computerIcon.setTitle(String.fontAwesomeIcon(name: .desktop), for: .normal)
        
        phoneIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        phoneIcon.setTitle(String.fontAwesomeIcon(name: .phone), for: .normal)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let clickerViewController =  storyboard.instantiateViewController(identifier: "clickerViewController") as? ClickerViewController else {
            assertionFailure("Couldn't find Profile VC")
            return
        }
        clickerViewController.user = self.user
        
        // Push to stack because we want users to be able to go back to clicker view
        let viewControllers = [clickerViewController]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
}
