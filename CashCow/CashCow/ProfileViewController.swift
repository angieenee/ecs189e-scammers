//
//  ProfileViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/21/21.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var incomeAmountLabel: UILabel!
    @IBOutlet weak var tapAmountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
