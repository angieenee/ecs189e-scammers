//
//  PopUpViewController.swift
//  CashCow
//
//  Created by Bridget Kelly on 3/10/21.
//

import UIKit

class PopUpViewController: UIViewController {
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func option1Pressed() {
        // self.user?.money?.moneyClick = self.user?.money?.add(self.user?.money?.moneyClick ?? ["_": 0], ["_": 0, "A": 5]) ?? ["_": 0]
        // TODO: insert -25% stamina option
        self.dismiss(animated: true)
    }
    
    @IBAction func option2Pressed() {
        // self.user?.money?.moneyPassive = self.user?.money?.add(self.user?.money?.moneyPassive ?? ["_": 0], ["_": 0, "A": 5])
        self.user?.money?.balance = self.user?.money?.subtract(self.user?.money?.balance ?? ["_": 0], ["_": 0, "A": 1]) ?? ["_": 0]
        self.dismiss(animated: true)
    }
    
    @IBAction func option3Pressed(_ sender: Any) {
        self.user?.money?.moneyClick = self.user?.money?.subtract(self.user?.money?.moneyClick ?? ["_": 0], ["_": 100]) ?? ["_": 0]
    }
}
