//
//  InfoPopupViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 3/15/21.
//

import UIKit

class InfoPopupViewController: UIViewController {

    @IBOutlet weak var instructionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        instructionsLabel.text = "Money: Tap the cow icon to generate income.\n\nStamina: Wait a few seconds to refill your stamina.\n\nUpgrades: Improve your $/click rate, $/sec passive rate, and stamina!\n\nStocks: Learn how to buy/sell stocks in real-time!"
    }
    
    @IBAction func tapToDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
