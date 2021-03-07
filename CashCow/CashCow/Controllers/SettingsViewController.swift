//
//  SettingsViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/21/21.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        // Reset things in clicker view
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        // Go back to login view
        
        // TODO: same code as the one in HomeView; maybe we should create a global function for cleaner code
        
        // FB Logout
        let loginManager = LoginManager()
        
        if let _ = AccessToken.current {
            loginManager.logOut()
        }
        
        GIDSignIn.sharedInstance()?.signOut()
        
        // Sign out from Firebase
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print ("Error signing out from Firebase: %@", error)
        }
        
        // Go back to login view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginViewController =  storyboard.instantiateViewController(identifier: "loginViewController") as? LoginViewController else {
            assertionFailure("Couldn't find Login VC")
            return
        }
        
        // Only have login view on stack so user can't go back
        let viewControllers = [loginViewController, self]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    

}
