//
//  HomeViewController.swift
//  WalletApp
//
//  Created by Bridget Kelly on 1/26/21.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var wallet: Wallet?
    var hole: Bool = false
    var placeholder: String?
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var totalBalance: UILabel!
    @IBOutlet weak var accountsTable: UITableView!
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountsTable.dataSource = self
        self.accountsTable.delegate = self
        
        self.userName.borderStyle = .none
        self.userName.minimumFontSize = 25
        
        // Get user from phone number
        Api.user(completion: {
            response, error in
            if let res = response {
                print("Response: ", res)
                
                let userData: [String: Any]? = res["user"] as? [String: Any]
                
                // Load data into wallet
                self.wallet = Wallet.init(data: res, ifGenerateAccounts: false)
                
                // Load user data onto view
                self.wallet?.printWallet()
                
                self.totalBalance.text = "Your total balance is: \(self.formatMoney(amount: self.wallet?.totalAmount ?? 0.00))"
                self.accountsTable.reloadData()
                self.userName.text = self.wallet?.userName ?? Storage.phoneNumberInE164
            
                // Save accounts
                Api.setAccounts(accounts: self.wallet?.accounts ?? [], completion: { response, error in
                    if let res = response {
                        print("Response: ", res)
                    }
                    if let err = error {
                        print("Error: ", err)
                    }
                })
            }
            if let err = error {
                print("Error: ", err)
                // Load empty user
                self.wallet = Wallet.init()
            }
            self.getPlaceholder()
        })
        
        self.tapGesture.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = accountsTable.indexPathForSelectedRow {
            accountsTable.deselectRow(at: selectedIndexPath, animated: animated)
        }
        self.navigationController?.isNavigationBarHidden = false
        self.accountsTable.reloadData()
        self.totalBalance.text = "Your total balance is: \(self.formatMoney(amount: self.wallet?.totalAmount ?? 0.00))"
        self.getPlaceholder()
    }
    
    func getPlaceholder() {
        var accountName = ""
        if let w = self.wallet {
            for i in 0..<w.accounts.count {
                let name = "Account \(i)"
                if name != w.accounts[i].name {
                    accountName = name
                    break
                }
            }
            if accountName == "" {
                accountName = "Account \(w.accounts.count)"
            }
        }
        self.placeholder = accountName
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
    
    @IBAction func logoutButtonPress(_ sender: Any) {
        // Navigate to login view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginViewController =  storyboard.instantiateViewController(identifier: "loginViewController") as? LoginViewController else {
            assertionFailure("Couldn't find VC")
            return
        }
        
        // Only have login view on stack so user can't go back
        let viewControllers = [loginViewController]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
        
        Storage.authToken = nil
    }
    
    @IBAction func addAccountButtonPress() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addAcctPopUpViewController =  storyboard.instantiateViewController(identifier: "addAcctPopUpViewController") as? AddAcctPopUpViewController else {
            assertionFailure("Couldn't find VC")
            return
        }
        addAcctPopUpViewController.wallet = self.wallet
        addAcctPopUpViewController.placeholder = self.placeholder
        self.present(addAcctPopUpViewController, animated: true)
    }
    
    @IBAction func outsideFieldTap(_ sender: Any) {
        view.endEditing(true)
        self.tapGesture.isEnabled = false
    }
    
    @IBAction func userNameTouchDown() {
        self.tapGesture.isEnabled = true
    }
    
    @IBAction func userNameEditingDidBegin() {
        self.userName.borderStyle = .roundedRect
    }
    
    @IBAction func userNameEditingDidEnd() {
        if self.userName.text == "" {
            self.userName.text = Storage.phoneNumberInE164
        }
        
        // Set username with API
        Api.setName(name: userName.text ?? "") { response, error in
            if let res = response {
                print("Response: ", res)
                // Success, update username in wallet
                self.wallet?.userName = self.userName.text
            }
            if let err = error {
                print("Error: ", err)
                // Reset username
                self.userName.text = self.wallet?.userName
            }
        }
        self.userName.borderStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Move to account view
        // Initialize new VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let accountViewController =  storyboard.instantiateViewController(identifier: "accountViewController") as? AccountViewController else {
            assertionFailure("Couldn't find VC")
            return
        }
        
        accountViewController.wallet = self.wallet
        accountViewController.index = indexPath.row
        
        self.navigationController?.pushViewController(accountViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == 0)
        return self.wallet?.accounts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell") ?? UITableViewCell(style: .default, reuseIdentifier: "accountCell")
        assert(indexPath.section == 0)
        cell.textLabel?.text = "\(self.wallet?.accounts[indexPath.row].name ?? ""): \(self.formatMoney(amount: self.wallet?.accounts[indexPath.row].amount ?? 0))"
        return cell
    }
}
