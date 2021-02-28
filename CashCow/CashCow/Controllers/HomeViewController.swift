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

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var helpPopupButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userRef = self.ref.child(firebaseAuth.currentUser?.uid ?? "")
        
        self.userRef?.observe(.value, with: { snapshot in
            if let data = snapshot.value as? [String: Any], let uid = self.firebaseAuth.currentUser?.uid {
                self.user.email = data["email"] as? String
                self.user.uid = uid
                
                if let username =  data["username"] as? String {
                    self.user.username = username
                } else {
                    if let email = self.user.email, let i = self.user.email?.firstIndex(of: "@") {
                        print("hello")
                        self.user.username = String(email[..<i])
                    }
                }
                
                if let username = self.user.username {
                    self.welcomeLabel.text = "Welcome, \(username)!"
                }
            }
            
            print("Email: \(self.user.email ?? "")")
            print("Username: \(self.user.username ?? "")")
            print("UID: \(self.user.uid ?? "")")
        })
        
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        // Go to clicker view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let clickerViewController =  storyboard.instantiateViewController(identifier: "clickerViewController") as? ClickerViewController else {
            assertionFailure("Couldn't find Clicker VC")
            return
        }
        
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
