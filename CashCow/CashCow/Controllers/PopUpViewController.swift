//
//  PopUpViewController.swift
//  CashCow
//
//  Created by Bridget Kelly on 3/10/21.
//

import UIKit
import Toast_Swift

class PopUpViewController: UIViewController {
    var user: User?
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Black out options that user cannot afford
//        if (!(user?.money?.validSubtraction(self.user?.money?.balance ?? ["_": 0], ["_": 0, "A": 1]) ?? false)) {
//            option2Button.backgroundColor = .lightGray
//            option2Button.isEnabled = false
//        }
//        if (!(user?.money?.validSubtraction(self.user?.money?.moneyClick ?? ["_": 0], ["_": 100, "A": 0]) ?? false)) {
//            option3Button.backgroundColor = .lightGray
//            option3Button.isEnabled = false
//        }
    }

    @IBAction func option1Pressed() {
        self.user?.money?.balance = self.user?.money?.subtract(self.user?.money?.balance ?? ["_": 0], ["_": 100, "A": 0]) ?? ["_": 0]
        
        self.user?.stamina = (self.user?.stamina ?? 1.25) - 0.25
        
        self.view.window?.makeToast("Groceries cost only 0.1A, but cooking the meal decreased your stamina by 25%!", duration: 3.0, position: .bottom)
        
        self.user?.save() {
            self.presentingViewController?.loadView()
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func option2Pressed() {
        // TODO: black out option if not enough balance
        self.user?.money?.balance = self.user?.money?.subtract(self.user?.money?.balance ?? ["_": 0], ["_": 0, "A": 1]) ?? ["_": 0]
        
        if (self.user?.stamina ?? 1.0) < 1.0 {
            self.user?.stamina = (self.user?.stamina ?? 1.25) + 0.25
        }
        
        self.view.window?.makeToast("MooDash cost 1A, but your laziness earned you a 25% increase in stamina!", duration: 3.0, position: .bottom)
        
        self.user?.save() {
            self.presentingViewController?.loadView()
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func option3Pressed(_ sender: Any) {
        // TODO: black out option if not enough click
        self.user?.money?.moneyClick = self.user?.money?.subtract(self.user?.money?.moneyClick ?? ["_": 0], ["_": 500]) ?? ["_": 0]
        
        self.view.window?.makeToast("Takeout cost 0.5A but had no effect on your stamina.", duration: 3.0, position: .bottom)
        
        self.user?.save() {
            self.presentingViewController?.loadView()
            self.dismiss(animated: true)
        }
    }
}
