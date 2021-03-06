//
//  HomeViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/17/21.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    var userRef: DatabaseReference?
    
    var ref = Database.database().reference(withPath: "users")
    var firebaseAuth = Auth.auth()
    var user = User()

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userRef = self.ref.child(firebaseAuth.currentUser?.uid ?? "")
        
        userRef.observe(.value, with: { snapshot in
            if let data = snapshot.value as? [String: Any] {
                self.user.load(data) {
                    if let username = self.user.username {
                        self.welcomeLabel.text = "Welcome, \(username)!"
                    }
                }
            } else {
                if let uid = Auth.auth().currentUser?.uid, let email = Auth.auth().currentUser?.email {
                    self.user.email = email
                    self.user.uid = uid
                    self.user.money = Mooooney.init()
                    
                    self.user.save() {
                        if let username = self.user.username {
                            self.welcomeLabel.text = "Welcome, \(username)!"
                        }
                    }
                }
            }
        })
        print("User: \(user)")
        self.user.push_upgrades() {
            print("success")
        }
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        // Go to clicker view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let clickerViewController =  storyboard.instantiateViewController(identifier: "clickerViewController") as? ClickerViewController else {
            assertionFailure("Couldn't find Clicker VC")
            return
        }
        
        clickerViewController.user = self.user
        
        // Push to stack because we want users to be able to go back to home view
        self.navigationController?.pushViewController(clickerViewController, animated: true)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
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
