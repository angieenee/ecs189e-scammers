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
    
    @IBOutlet weak var googleLoginButton: AZSocialButton!
    @IBOutlet weak var facebookLoginButton: AZSocialButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if let _ = AccessToken.current {
            self.navHomeView()
        } else if GIDSignIn.sharedInstance()?.currentUser != nil {
            self.navHomeView()
        }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        self.set(button: googleLoginButton, image: UIImage(named: "ic_google") ?? UIImage(), with: "  Sign In with Google")
        self.set(button: facebookLoginButton, image: UIImage(named: "ic_facebook") ?? UIImage(), with: "  Sign In with Facebook")
        facebookLoginButton.backgroundColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1)
        
        // Notification for Google login
        NotificationCenter.default.addObserver(self, selector: #selector(userDidSignInGoogle(_:)), name: .signInGoogleCompleted, object: nil)
    }
    
    @IBAction func loginGooglePress() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func loginFacebookPress() {
        let loginManager = LoginManager()
            
        loginManager.logIn(permissions: [], from: self) { [weak self] (result, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            if let res = result {
                if res.isCancelled {
                    print("User cancelled login")
                    return
                }
                
                // Success - auth and nav to home view
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "")
                print("Credential: \(credential)")
                
                // Authenticate with Firebase using the credential object
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                    }
                }
                self?.navHomeView()
            }
        }
    }
    
    @IBAction func loginEmailPress() {
        // Nav to home view for now until login w/ email is implemented
        self.navHomeView()
    }
    
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
        
        if let uid = Auth.auth().currentUser?.uid, let email = Auth.auth().currentUser?.email {
            ref.child(uid).setValue(["email": email]) {
                (error: Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data saved successfully!")
                    self.navHomeView()
                }
            }
        }
    }
}

