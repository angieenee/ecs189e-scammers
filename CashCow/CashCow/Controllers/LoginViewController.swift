//
//  ViewController.swift
//  CashCow
//
//  Created by Bridget Kelly on 2/14/21.
//

import UIKit
import EasySocialButton
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    var ref = Database.database().reference(withPath: "users")
    var firebaseAuth = Auth.auth()
    
    @IBOutlet weak var googleLoginButton: AZSocialButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if let _ = AccessToken.current {
            self.navHomeView()
        } else if GIDSignIn.sharedInstance()?.currentUser != nil {
            self.navHomeView()
        }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Set UI for button
        self.set(button: googleLoginButton, image: UIImage(named: "ic_google") ?? UIImage(), with: "  Sign In with Google")
        
        // Notification for Google login
        NotificationCenter.default.addObserver(self, selector: #selector(userDidSignInGoogle(_:)), name: .signInGoogleCompleted, object: nil)
    }
    
    @IBAction func loginGooglePress() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // Customize button
    func set(button: AZSocialButton, image: UIImage, with text: String) {
      let attachment = NSTextAttachment()
      attachment.image = image
      attachment.bounds = CGRect(x: 0, y: -10, width: 30, height: 30)
      let attachmentStr = NSAttributedString(attachment: attachment)

      let mutableAttributedString = NSMutableAttributedString()
      mutableAttributedString.append(attachmentStr)

      let textString = NSAttributedString(string: text)
      mutableAttributedString.append(textString)

      button.setAttributedTitle(mutableAttributedString, for: UIControl.State.normal)
    }
    
    // Go to home view
    private func navHomeView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeViewController =  storyboard.instantiateViewController(identifier: "homeViewController") as? HomeViewController else {
            assertionFailure("Couldn't find VC")
            return
        }
        
        // Only have home view on stack so user can't go back
        let viewControllers = [homeViewController]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
    // MARK:- Notification
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        // Update screen after user successfully signed in
        print("signed in")
        self.navHomeView()
    }
}

