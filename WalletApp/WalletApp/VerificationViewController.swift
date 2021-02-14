//
//  VerificationViewController.swift
//  WalletApp
//
//  Created by Bridget Kelly on 1/25/21.
//

import UIKit

class VerificationViewController: UIViewController, PinTexFieldDelegate {
    
    var formattedNumber: String?
    private var fields: [UITextField]?
    
    @IBOutlet weak var formattedNumberLabel: UILabel!
    
    @IBOutlet weak var numberField1: PinTextField!
    @IBOutlet weak var numberField2: PinTextField!
    @IBOutlet weak var numberField3: PinTextField!
    @IBOutlet weak var numberField4: PinTextField!
    @IBOutlet weak var numberField5: PinTextField!
    @IBOutlet weak var numberField6: PinTextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numberField1.becomeFirstResponder()
        
        // Send OTP to phone number
        self.formattedNumberLabel.text = "Enter the code sent to \(self.formattedNumber ?? "")"
        
        // Setup for OTP fields
        fields = [numberField1, numberField2, numberField3, numberField4, numberField5, numberField6]
        
        // Set up delegates
        (fields ?? []).map { $0.delegate = self}
        (fields ?? []).map { $0.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged) }
        (fields ?? []).map { $0.keyboardType = UIKeyboardType.phonePad }
    
    }
    
    // Move cursor to right when user touch text field
    @IBAction func textFieldTouchDown(_ sender: Any) {
        if let textField = sender as? PinTextField {
            textField.becomeFirstResponder()
            textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        let nextField = getNextField(fields: fields ?? [], currentField: textField)
        
        var code = ""
        for field in fields ?? [] {
            code += field.text ?? ""
        }
        print(code)
        
        if code.count == 6 {
            // Check if code is correct
            Api.verifyCode(phoneNumber: formattedNumber ?? "", code: code, completion: {
                response, error in
                if let res = response {
                    // Code is correct
                    print("Response: ", res)
                    self.errorLabel.text = ""
                    
                    let authToken = res["auth_token"] as? String
                    let user = res["user"] as? [String: Any]
                    let phoneNumber = user?["e164_phone_number"] as? String
                    
                    Storage.authToken = authToken
                    Storage.phoneNumberInE164 = phoneNumber
                    
                    // Change to home view
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let homeViewController =  storyboard.instantiateViewController(identifier: "homeViewController") as? HomeViewController else {
                        assertionFailure("Couldn't find VC")
                        return
                    }
                    
                    // Only have home view on stack so user can't go back
                    let viewControllers = [homeViewController]
                    self.navigationController?.setViewControllers(viewControllers, animated: true)
                }
                if let err = error {
                    // Issue with code, let user know
                    print("Error: ", err)
                    self.errorLabel.text = err.message
                }
            })
            
            self.numberField6?.becomeFirstResponder()
        } else if numberField1.text?.isEmpty == false, textField.text?.isEmpty == false {
            // Otherwise force move to next field
            nextField?.becomeFirstResponder()
        }
        
        for index in 0 ..< 6 {
            if let field = fields?[index] {
                if index >= code.count {
                    field.text = ""
                } else {
                    let i = code.index(code.startIndex, offsetBy: index)
                    field.text = "\(code[i])"
                }
            }
        }
    }
    
    func didPressBackspace(textField: PinTextField) {
        // Move to previous field
        let prevField = getPrevField(fields: fields ?? [], currentField: textField)
        
        if prevField != nil, textField.text?.isEmpty == true {
            prevField?.becomeFirstResponder()
            prevField?.text = ""
        }

    }
    
    // Returns next field in list
    func getNextField(fields: [UITextField], currentField: UITextField) -> UITextField? {
        for (current, next) in zip(fields, fields.dropFirst()) {
            if currentField == current {
                return next
            }
        }
        // Must be last field, return nil
        return nil
    }
    
    // Returns previous field in list
    func getPrevField(fields: [UITextField], currentField: UITextField) -> UITextField? {
        for (current, prev) in zip(fields.dropFirst(), fields) {
            if currentField == current {
                return prev
            }
        }
        // Must be first field, return nil
        return nil
    }
    
    // Resend OTP to phone number
    @IBAction func resendCodeButtonPress() {
        Api.sendVerificationCode(phoneNumber: formattedNumber ?? "", completion: {
            response, error in
            if let res = response {
                print("Response: ", res)
                
            }
            if let err = error {
                print("Error: ", err)
            }
        })
        self.errorLabel.text = "Verification code resent."
    }
    
}
