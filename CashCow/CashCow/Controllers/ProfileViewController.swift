//
//  ProfileViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/21/21.
//

import UIKit

class ProfileViewController: UIViewController {
    var user: User?
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var incomeAmountLabel: UILabel!
    @IBOutlet weak var tapAmountLabel: UILabel!
    @IBOutlet weak var passiveAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameLabel.text = self.user?.username
        self.incomeAmountLabel.text = self.user?.money?.getBalance()
        self.tapAmountLabel.text = self.user?.money?.getMoneyClick()
        self.passiveAmountLabel.text = self.user?.money?.getMoneyPassive()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let clickerViewController =  storyboard.instantiateViewController(identifier: "clickerViewController") as? ClickerViewController else {
            assertionFailure("Couldn't find Profile VC")
            return
        }
        clickerViewController.user = self.user
        
        // Push to stack because we want users to be able to go back to clicker view
        let viewControllers = [clickerViewController]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }

}
