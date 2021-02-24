//
//  UpgradesViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/21/21.
//

import UIKit

class UpgradesViewController: UIViewController {
    
    // Icon buttons
    
    // TODO: use FontAwesome
    @IBOutlet weak var coffeeIcon: UIButton!
    @IBOutlet weak var diningIcon: UIButton!
    @IBOutlet weak var sleepIcon: UIButton!
    
    @IBOutlet weak var briefcaseIcon: UIButton!
    @IBOutlet weak var computerIcon: UIButton!
    
    // Amount labels
    @IBOutlet weak var coffeeAmountLabel: UILabel!
    
    // Progress bars
    
    
    // Initialize consts for amounts here
    let coffeeAmount = "5a"
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: check if this actually works lol
        var amountsList = [self.coffeeAmount]
        
        let amountLabelsList = [self.coffeeAmountLabel]
                
        // Prepend $ to all consts using map
        amountsList = amountsList.map{"$" + $0}
                
        // Set amount labels to respective consts
        for (amountLabel, amounts) in zip(amountLabelsList, amountsList) {
            amountLabel?.text = amounts
        }
    }
    

}
