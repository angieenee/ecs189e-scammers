//
//  AccountViewController.swift
//  WalletApp
//
//  Created by Bridget Kelly on 2/10/21.
//

import UIKit

class AccountViewController: UIViewController {
    
    var wallet: Wallet?
    var index: Int?
    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountTotalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        // Set account labels
        if let i: Int = index, let w: Wallet = wallet {
            self.accountNameLabel.text = w.accounts[i].name
            self.accountTotalLabel.text = "\(self.formatMoney(amount: w.accounts[i].amount))"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let i: Int = index, let w: Wallet = wallet {
            self.accountTotalLabel.text = "\(self.formatMoney(amount: w.accounts[i].amount))"
        }
    }
    
    // Go back to HomeView
    @IBAction func exitButtonPress() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Deposit button pressed
    @IBAction func depositAccount() {
        let alert = UIAlertController(title: "Deposit into \(self.accountNameLabel.text ?? "")", message: "Enter an amount.", preferredStyle: .alert)
        alert.addTextField{ (field) in
            field.placeholder = "Amount"
            field.clearButtonMode = .whileEditing
            field.keyboardType = UIKeyboardType.decimalPad
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            self.wait()
            if let deposit = alert.textFields?[0].text, let i: Int = self.index, let w: Wallet = self.wallet {
                Api.deposit(wallet: w, toAccountAt: i, amount: Double(deposit) ?? 0, completion: { response, error in
                        if let res = response {
                            print(res)
                            self.accountTotalLabel.text = "\(self.formatMoney(amount: w.accounts[i].amount))"
                        }
                        if let err = error {
                            print(err)
                        }
                        self.start()
                })
            }
        }

        alert.addAction(submitAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Withdraw button pressed
    @IBAction func withdrawAccount() {
        // Set up UIAlert
        let alert = UIAlertController(title: "Withdraw from \(self.accountNameLabel.text ?? "")", message: "Enter an amount.", preferredStyle: .alert)
        
        alert.addTextField{ (field) in
            field.placeholder = "Amount"
            field.clearButtonMode = .whileEditing
            field.keyboardType = UIKeyboardType.decimalPad
        }
        
        // Action when user presses submit button
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            self.wait()
            if let withdrawal = alert.textFields?[0].text, let i: Int = self.index, let w: Wallet = self.wallet {
                // Check if withdrawal amount exceeds account balance
                let wd = (Double(withdrawal) ?? 0) < w.accounts[i].amount ? (Double(withdrawal) ?? 0) : w.accounts[i].amount
                Api.withdraw(wallet: w, fromAccountAt: i, amount: wd, completion: { response, error in
                        if let res = response {
                            print(res)
                            // Reflect change on AccountView
                            self.accountTotalLabel.text = "\(self.formatMoney(amount: w.accounts[i].amount))"
                        }
                        if let err = error {
                            print(err)
                        }
                        self.start()
                })
            }
        }

        alert.addAction(submitAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Transfer button pressed
    @IBAction func transferAccount() {
        // Present TransferAcctPopUpViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let transferAcctPopUpViewController =  storyboard.instantiateViewController(identifier: "transferAcctPopUpViewController") as? TransferAcctPopUpViewController else {
            assertionFailure("Couldn't find VC")
            return
        }
        
        // Set class variables
        transferAcctPopUpViewController.wallet = wallet
        transferAcctPopUpViewController.currAcct = index
        
        self.present(transferAcctPopUpViewController, animated: true)
    }
    
    // Delete button pressed
    @IBAction func deleteAccount() {
        wait()
        if let i: Int = index, let w: Wallet = wallet {
            Api.removeAccount(wallet: w, removeAccountat: i, completion: { response, error in
                if let res = response {
                    print(res)
                }
                if let err = error {
                    print(err)
                }
                
                // Navigate to HomeView on completion
                self.navigationController?.popViewController(animated: true)
            })
        } else {
            print("Index/wallet are nil")
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
}
