//
//  PopUpViewController.swift
//  WalletApp
//
//  Created by Bridget Kelly on 2/10/21.
//

import UIKit

class AddAcctPopUpViewController: UIViewController {

    var wallet: Wallet?
    var placeholder: String?
    
    @IBOutlet weak var accountName: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountName.becomeFirstResponder()
        self.accountName.placeholder = self.placeholder
    }
    
    @IBAction func submitButtonPress() {
        self.wait()
        
        // Set name to placeholder if accountName field is empty
        if let name = (accountName.text != "" ? accountName.text : accountName.placeholder), let w = wallet {
            Api.addNewAccount(wallet: w, newAccountName: name, completion: { response, error in
                if let res = response {
                    print(res)
                }
                if let err = error {
                    print(err)
                }
                
                // Update HomeViewController
                self.presentingViewController?.loadView()
                
                // Dismiss popup
                self.dismiss(animated: true, completion: {
                    self.start()
                })
            })
        }
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
