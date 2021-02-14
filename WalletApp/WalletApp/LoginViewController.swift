//
//  ViewController.swift
//  WalletApp
//
//  Created by Bridget Kelly on 1/17/21.
//

import UIKit
import PhoneNumberKit

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneNumberField: PhoneNumberTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var sendCodeButton: UIButton!
    
    let phoneNumberKit = PhoneNumberKit()
    let errorCodes: (String, String, String) = ("Please enter a phone number.", "Invalid phone number entered. Try again.", "Error sending verification code.")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove country code and use phone number placeholder
        self.phoneNumberField.withPrefix = false
        self.phoneNumberField.withExamplePlaceholder = true
        self.phoneNumberField.text = Storage.phoneNumberInE164
        self.phoneNumberField.clearButtonMode = .always
    }

    // Dismisses keyboard when user taps outside phoneNumberField
    @IBAction func outsideFieldTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // Dismisses keyboard and verifies phone number in phoneNumberField
    @IBAction func sendCodeButtonPress() {
        self.view.endEditing(true)
        
        let phoneNumberText = phoneNumberField.text ?? ""
        do {
            let phoneNumber = try phoneNumberKit.parse(phoneNumberText)
            let formattedNumber = phoneNumberKit.format(phoneNumber, toType: .e164)
            print(formattedNumber)
            
            // If user was last to login - skip verification
            if Storage.authToken != nil, Storage.phoneNumberInE164 == formattedNumber {
                // Change to home view
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let homeViewController =  storyboard.instantiateViewController(identifier: "homeViewController") as? HomeViewController else {
                    assertionFailure("Couldn't find VC")
                    return
                }

                // Only have home view on stack so user can't go back
                let viewControllers = [homeViewController]
                self.navigationController?.setViewControllers(viewControllers, animated: true)
            } else {
                // Otherwise verify
                Api.sendVerificationCode(phoneNumber: formattedNumber, completion: {
                    response, error in
                    if let res = response {
                        print("Response: ", res)
                        // Initialize new VC
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        guard let verificationViewController =  storyboard.instantiateViewController(identifier: "verificationViewController") as? VerificationViewController else {
                            assertionFailure("Couldn't find VC")
                            return
                        }
                    
                        // Pass .e164 phone number to VC and change views
                        verificationViewController.formattedNumber = formattedNumber
                        self.navigationController?.pushViewController(verificationViewController, animated: true)
                    }
                    if let err = error {
                        print("Error: ", err)
                        self.errorLabel.text = self.errorCodes.2
                    }
                })
            }
        } catch {
            print("Invalid number")
            if phoneNumberText == "" {
                errorLabel.text = errorCodes.0
            } else {
                errorLabel.text = errorCodes.1
            }
        }
    }
}

