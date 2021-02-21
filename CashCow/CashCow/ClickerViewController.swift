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
    int stamina = 5
    // M1: save user's income
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: display user's saved income, stamina
        
        
    }
    
    // TODO: clicker functionality
    @IBAction func cowClicked(_ sender: Any) {
    }
    
    // TODO: update stamina bar
    func updateStamina {
        
    }

}
