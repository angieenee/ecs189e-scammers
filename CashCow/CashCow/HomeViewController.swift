//
//  HomeViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/17/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var helpPopupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        // Go to clicker view
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        // Go back to login view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginViewController =  storyboard.instantiateViewController(identifier: "loginViewController") as? LoginViewController else {
            assertionFailure("Couldn't find Login VC")
            return
        }
        
        // Only have login view on stack so user can't go back
        let viewControllers = [loginViewController]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
    

}
