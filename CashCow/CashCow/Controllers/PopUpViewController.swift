//
//  PopUpViewController.swift
//  CashCow
//
//  Created by Bridget Kelly on 3/10/21.
//

import UIKit

class PopUpViewController: UIViewController {
    var user: User?
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Black out options that user cannot afford
        if (!(user?.money?.validSubtraction(self.user?.money?.balance ?? ["_": 0], ["_": 0, "A": 1]) ?? false)) {
            option2Button.backgroundColor = .lightGray
            option2Button.isEnabled = false
        }
        if (!(user?.money?.validSubtraction(self.user?.money?.moneyClick ?? ["_": 0], ["_": 100]) ?? false)) {
            option3Button.backgroundColor = .lightGray
            option3Button.isEnabled = false
        }
    }

    @IBAction func option1Pressed() {
        // FIXME: I am unable to decrease stamina
        (self.presentingViewController as? ClickerViewController)?.staminaBar.progress -= 0.25
        
        self.dismiss(animated: true)
    }
    
    @IBAction func option2Pressed() {
        // TODO: black out option if not enough balance
        self.user?.money?.balance = self.user?.money?.subtract(self.user?.money?.balance ?? ["_": 0], ["_": 0, "A": 1]) ?? ["_": 0]
        self.dismiss(animated: true)
    }
    
    @IBAction func option3Pressed(_ sender: Any) {
        // TODO: black out option if not enough click
        self.user?.money?.moneyClick = self.user?.money?.subtract(self.user?.money?.moneyClick ?? ["_": 0], ["_": 100]) ?? ["_": 0]
        self.dismiss(animated: true)
    }
}
