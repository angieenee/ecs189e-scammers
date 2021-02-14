//
//  TransferAcctPopUpViewController.swift
//  WalletApp
//
//  Created by Bridget Kelly on 2/12/21.
//

import UIKit

class TransferAcctPopUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var wallet: Wallet?
    var currAcct: Int?
    var accounts: [Account] = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.amount.keyboardType = UIKeyboardType.decimalPad
        self.errorLabel.text = ""
        
        // Set accounts for pickerView
        if let w = self.wallet, let i = self.currAcct {
            for j in 0..<w.accounts.count {
                if i != j {
                    self.accounts.append(w.accounts[j])
                }
            }
        }
    }

    @IBAction func submitButtonPress() {
        self.wait()
        
        // Increment index by one if user picked account with larger index than current
        let index = pickerView.selectedRow(inComponent: 0) < (currAcct ?? 0) ? pickerView.selectedRow(inComponent: 0) : pickerView.selectedRow(inComponent: 0) + 1
        
        if let w = wallet, let from = currAcct {
            // Check for larger transfer amount than account balance
            var transferAmount = Double(self.amount.text ?? "0") ?? 0
            transferAmount = transferAmount < w.accounts[from].amount ? transferAmount : w.accounts[from].amount
            
            // Reflect this check if necessary
            errorLabel.text = transferAmount < w.accounts[from].amount ? "" : "Max transfer detected."

            Api.transfer(wallet: w, fromAccountAt: from, toAccountAt: index, amount: transferAmount, completion: { response, error in
                if let res = response {
                    print(res)
                }
                if let err = error {
                    print(err)
                }

                // Update AccountViewController
                self.presentingViewController?.loadView()

                // Dismiss popup
                self.dismiss(animated: true, completion: {
                    self.start()
                })
            })
        }
    }
    
    func formatMoney(amount: Double) -> String {
        let charactersRev: [Character] = String(format: "$%.02f", amount).reversed()
        if charactersRev.count < 7 {
            return String(format: "$%.02f", amount)
        }
        var newChars: [Character] = []
        for (index, char) in zip(0...(charactersRev.count-1), charactersRev) {
            if (index-6)%3 == 0 && (index-6) > -1 && char != "$"{
                newChars.append(",")
                newChars.append(char)
            } else {
                newChars.append(char)
            }
        }
        
        return String(newChars.reversed())
    }
    
    // activityIndicator methods
    func wait() {
        self.activityIndicator.startAnimating()
        self.view.alpha = 0.8
        self.view.isUserInteractionEnabled = false
    }
    
    func start() {
        self.activityIndicator.stopAnimating()
        self.view.alpha = 1
        self.view.isUserInteractionEnabled = true
    }
    
    // Protocol stubs for pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.wallet?.accounts.count ?? 1) - 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.accounts[row].name): \(self.formatMoney(amount: self.accounts[row].amount))"
    }
    
}
