//
//  PopUpViewController.swift
//  CashCow
//
//  Created by Bridget Kelly on 3/10/21.
//

import UIKit
import Toast_Swift
import FirebaseDatabase

class PopUpViewController: UIViewController {
    var user: User?
    var decisions: [Decision]?
    var decision: Decision?
    
    var viewControllerTransitionListener = ViewControllerTransitionMediator()
    
    var numOfInvalidOptions = 0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !(self.decisions?.isEmpty ?? true) {
            decision = self.decisions?[0]
        }
       
        if decision == nil {
            print("Uh oh, decisions is empty!")
            self.presentingViewController?.loadView()
            self.dismiss(animated: true, completion: {self.viewControllerTransitionListener.sendDecisionPopupDismissed(true)})
        }
        
        print("DECISION --")
        dump(self.decision)
        
        // Set up label and button text
        self.titleLabel.text = self.decision?.name
        self.descriptionLabel.text = self.decision?.description
        self.option1Button.setTitle(self.decision?.option1text, for: .normal)
        self.option2Button.setTitle(self.decision?.option2text, for: .normal)
        self.option3Button.setTitle(self.decision?.option3text, for: .normal)
        
        // Black out options that user cannot afford
        // Option 1:
        if let passiveSubtract = self.decision?.option1change?["passive"]?["subtract"] {
            if (!(user?.money?.validSubtraction(user?.money?.moneyPassive ?? ["_": 0, "A": 0], passiveSubtract) ?? false)) {
                print("NOT ENOUGH PASSIVE FOR OP 1")
                option1Button.isEnabled = false
                option1Button.backgroundColor = .lightGray
                numOfInvalidOptions += 1
            }
        }
        if let clickerSubtract = self.decision?.option1change?["clicker"]?["subtract"] {
            if (!(user?.money?.validSubtraction(user?.money?.moneyClick ?? ["_": 0, "A": 0], clickerSubtract) ?? false)) {
                print("NOT ENOUGH CLICKER FOR OP 1")
                option1Button.isEnabled = false
                option1Button.backgroundColor = .lightGray
                numOfInvalidOptions += 1
            }
        }
        if let balanceSubtract = self.decision?.option1change?["balance"]?["subtract"] {
            print("USER BALANCE -- ", self.user?.money?.balance)
            print("BALANCE SUBTRACT -- ", balanceSubtract)
            print("VALID SUBTRACTION -- ", self.user?.money?.validSubtraction(user?.money?.balance ?? ["_": 0, "A": 0], balanceSubtract))
            if (!(self.user?.money?.validSubtraction(self.user?.money?.balance ?? ["_": 0, "A": 0], balanceSubtract) ?? false)) {
                print("NOT ENOUGH BALANCE FOR OP 1")
                option1Button.isEnabled = false
                option1Button.backgroundColor = .lightGray
                numOfInvalidOptions += 1
            }
        }
        
        // Option 2:
        if let passiveSubtract = self.decision?.option2change?["passive"]?["subtract"] {
            if (!(user?.money?.validSubtraction(user?.money?.moneyPassive ?? ["_": 0, "A": 0], passiveSubtract) ?? false)) {
                option2Button.isEnabled = false
                option2Button.backgroundColor = .lightGray
                numOfInvalidOptions += 1
            }
        }
        if let clickerSubtract = self.decision?.option2change?["clicker"]?["subtract"] {
            if (!(user?.money?.validSubtraction(user?.money?.moneyClick ?? ["_": 0, "A": 0], clickerSubtract) ?? false)) {
                option2Button.isEnabled = false
                option2Button.backgroundColor = .lightGray
                numOfInvalidOptions += 1
            }
        }
        if let balanceSubtract = self.decision?.option1change?["balance"]?["subtract"] {
            if (!(user?.money?.validSubtraction(user?.money?.balance ?? ["_": 0, "A": 0], balanceSubtract) ?? false)) {
                option2Button.isEnabled = false
                option2Button.backgroundColor = .lightGray
                numOfInvalidOptions += 1
            }
        }
        
        // Option 3:
        if (self.decision?.numOptions ?? 3 < 3) {
            // Hide button if no third option exists
            option3Button.isHidden = true
        } else {
            if let passiveSubtract = self.decision?.option3change?["passive"]?["subtract"] {
                if (!(user?.money?.validSubtraction(user?.money?.moneyPassive ?? ["_": 0, "A": 0], passiveSubtract) ?? false)) {
                    option3Button.isEnabled = false
                    option3Button.backgroundColor = .lightGray
                    numOfInvalidOptions += 1
                }
            }
            if let clickerSubtract = self.decision?.option3change?["clicker"]?["subtract"] {
                if (!(user?.money?.validSubtraction(user?.money?.moneyClick ?? ["_": 0, "A": 0], clickerSubtract) ?? false)) {
                    option3Button.isEnabled = false
                    option3Button.backgroundColor = .lightGray
                    numOfInvalidOptions += 1
                }
            }
            if let balanceSubtract = self.decision?.option3change?["balance"]?["subtract"] {
                if (!(user?.money?.validSubtraction(user?.money?.balance ?? ["_": 0, "A": 0], balanceSubtract) ?? false)) {
                    option3Button.isEnabled = false
                    option3Button.backgroundColor = .lightGray
                    numOfInvalidOptions += 1
                }
            }
        }
        
        // TODO: does not dismiss popup :(
        print("NUM OF INVALID OPTIONS -- ", numOfInvalidOptions)
        
        if (numOfInvalidOptions >= 3) {
            print("DISMISS HOEEE")
            self.dismiss(animated: true, completion: {self.viewControllerTransitionListener.sendDecisionPopupDismissed(true)})
        }
    }
    
    @IBAction func option1Pressed() {
        // Check which user stat to update:
        // Balance add/subtract:
        if let balanceSubtract = self.decision?.option1change?["balance"]?["subtract"] {
            user?.money?.balance = user?.money?.subtract(user?.money?.balance ?? ["_": 0, "A": 0], balanceSubtract) ?? ["_": 0, "A": 0]
        }
        if let balanceAdd = self.decision?.option1change?["balance"]?["add"] {
            user?.money?.balance = user?.money?.add(user?.money?.balance ?? ["_": 0, "A": 0], balanceAdd) ?? ["_": 0, "A": 0]
        }
        // Clicker add/subtract:
        if let clickerSubtract = self.decision?.option1change?["clicker"]?["subtract"] {
            user?.money?.moneyClick = user?.money?.subtract(user?.money?.moneyClick ?? ["_": 0, "A": 0], clickerSubtract) ?? ["_": 0, "A": 0]
        }
        if let clickerAdd = self.decision?.option1change?["clicker"]?["add"] {
            user?.money?.moneyClick = user?.money?.add(user?.money?.moneyClick ?? ["_": 0, "A": 0], clickerAdd) ?? ["_": 0, "A": 0]
        }
        // Passive add/subtract:
        if let passiveSubtract = self.decision?.option1change?["passive"]?["subtract"] {
            user?.money?.moneyPassive = user?.money?.subtract(user?.money?.moneyPassive ?? ["_": 0, "A": 0], passiveSubtract) ?? ["_": 0, "A": 0]
        }
        if let passiveAdd = self.decision?.option1change?["passive"]?["add"] {
            user?.money?.moneyPassive = user?.money?.add(user?.money?.moneyPassive ?? ["_": 0, "A": 0], passiveAdd) ?? ["_": 0, "A": 0]
        }
        // Stamina add/subtract:
        if let staminaSubtract = self.decision?.option1change?["stamina"]?["subtract"] {
            user?.stamina = (user?.stamina ?? 0.0) - Float((staminaSubtract["_"] ?? 0)) / 100.0
            if (user?.stamina ?? 0.0 < 0.0) {
                user?.stamina = 0.0
            }
        }
        if let staminaAdd = self.decision?.option1change?["stamina"]?["add"] {
            user?.stamina = user?.stamina ?? 0.0 + Float((staminaAdd["_"] ?? 0)) / 100.0
            if (user?.stamina ?? 0.0 > 1.0) {
                user?.stamina = 100
            }
        }
        
        self.user?.save() {
            self.presentingViewController?.loadView()
            self.dismiss(animated: true, completion: {self.viewControllerTransitionListener.sendDecisionPopupDismissed(true)})
        }
    }
    
    @IBAction func option2Pressed() {
        // Check which user stat to update:
        // Balance add/subtract:
        if let balanceSubtract = self.decision?.option2change?["balance"]?["subtract"] {
            user?.money?.balance = user?.money?.subtract(user?.money?.balance ?? ["_": 0, "A": 0], balanceSubtract) ?? ["_": 0, "A": 0]
        }
        if let balanceAdd = self.decision?.option2change?["balance"]?["add"] {
            user?.money?.balance = user?.money?.add(user?.money?.balance ?? ["_": 0, "A": 0], balanceAdd) ?? ["_": 0, "A": 0]
        }
        // Clicker add/subtract:
        if let clickerSubtract = self.decision?.option2change?["clicker"]?["subtract"] {
            user?.money?.moneyClick = user?.money?.subtract(user?.money?.moneyClick ?? ["_": 0, "A": 0], clickerSubtract) ?? ["_": 0, "A": 0]
        }
        if let clickerAdd = self.decision?.option2change?["clicker"]?["add"] {
            user?.money?.moneyClick = user?.money?.add(user?.money?.moneyClick ?? ["_": 0, "A": 0], clickerAdd) ?? ["_": 0, "A": 0]
        }
        // Passive add/subtract:
        if let passiveSubtract = self.decision?.option2change?["passive"]?["subtract"] {
            user?.money?.moneyPassive = user?.money?.subtract(user?.money?.moneyPassive ?? ["_": 0, "A": 0], passiveSubtract) ?? ["_": 0, "A": 0]
        }
        if let passiveAdd = self.decision?.option2change?["passive"]?["add"] {
            user?.money?.moneyPassive = user?.money?.add(user?.money?.moneyPassive ?? ["_": 0, "A": 0], passiveAdd) ?? ["_": 0, "A": 0]
        }
        // Stamina add/subtract:
        if let staminaSubtract = self.decision?.option2change?["stamina"]?["subtract"] {
            user?.stamina = user?.stamina ?? 0.0 - (Float(staminaSubtract["_"] ?? 0)) / 100.0
            if (user?.stamina ?? 0.0 < 0.0) {
                user?.stamina = 0.0
            }
        }
        if let staminaAdd = self.decision?.option2change?["stamina"]?["add"] {
            user?.stamina = user?.stamina ?? 0.0 + (Float(staminaAdd["_"] ?? 0)) / 100.0
            if (user?.stamina ?? 0.0 > 1.0) {
                user?.stamina = 100
            }
        }
        
        self.user?.save() {
            self.presentingViewController?.loadView()
            self.dismiss(animated: true, completion: {self.viewControllerTransitionListener.sendDecisionPopupDismissed(true)})
        }
    }
    
    @IBAction func option3Pressed(_ sender: Any) {
        // Check which user stat to update:
        // Balance add/subtract:
        if let balanceSubtract = self.decision?.option3change?["balance"]?["subtract"] {
            user?.money?.balance = user?.money?.subtract(user?.money?.balance ?? ["_": 0, "A": 0], balanceSubtract) ?? ["_": 0, "A": 0]
        }
        if let balanceAdd = self.decision?.option3change?["balance"]?["add"] {
            user?.money?.balance = user?.money?.add(user?.money?.balance ?? ["_": 0, "A": 0], balanceAdd) ?? ["_": 0, "A": 0]
        }
        // Clicker add/subtract:
        if let clickerSubtract = self.decision?.option3change?["clicker"]?["subtract"] {
            user?.money?.moneyClick = user?.money?.subtract(user?.money?.moneyClick ?? ["_": 0, "A": 0], clickerSubtract) ?? ["_": 0, "A": 0]
        }
        if let clickerAdd = self.decision?.option3change?["clicker"]?["add"] {
            user?.money?.moneyClick = user?.money?.add(user?.money?.moneyClick ?? ["_": 0, "A": 0], clickerAdd) ?? ["_": 0, "A": 0]
        }
        // Passive add/subtract:
        if let passiveSubtract = self.decision?.option3change?["passive"]?["subtract"] {
            user?.money?.moneyPassive = user?.money?.subtract(user?.money?.moneyPassive ?? ["_": 0, "A": 0], passiveSubtract) ?? ["_": 0, "A": 0]
        }
        if let passiveAdd = self.decision?.option3change?["passive"]?["add"] {
            user?.money?.moneyPassive = user?.money?.add(user?.money?.moneyPassive ?? ["_": 0, "A": 0], passiveAdd) ?? ["_": 0, "A": 0]
        }
        // Stamina add/subtract:
        if let staminaSubtract = self.decision?.option3change?["stamina"]?["subtract"] {
            user?.stamina = (user?.stamina ?? 0.0) - (Float(staminaSubtract["_"] ?? 0)) / 100.0
            if (user?.stamina ?? 0.0 < 0.0) {
                user?.stamina = 0.0
            }
        }
        if let staminaAdd = self.decision?.option3change?["stamina"]?["add"] {
            user?.stamina = user?.stamina ?? 0.0 + (Float(staminaAdd["_"] ?? 0)) / 100.0
            if (user?.stamina ?? 0.0 > 1.0) {
                user?.stamina = 100
            }
        }
        
        self.user?.save() {
            self.presentingViewController?.loadView()
            self.dismiss(animated: true, completion: {self.viewControllerTransitionListener.sendDecisionPopupDismissed(true)})
        }
    }
}
