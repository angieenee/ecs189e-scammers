//
//  ViewController.swift
//  CashCow
//
//  Created by Bridget Kelly on 2/14/21.
//

import UIKit
import EasySocialButton

class LoginViewController: UIViewController {
    
    @IBOutlet weak var googleLoginButton: AZSocialButton!
    @IBOutlet weak var facebookLoginButton: AZSocialButton!
    @IBOutlet weak var emailLoginButton: AZSocialButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.set(button: googleLoginButton, image: UIImage(named: "ic_google") ?? UIImage(), with: "  Sign In with Google")
        self.set(button: facebookLoginButton, image: UIImage(named: "ic_facebook") ?? UIImage(), with: "  Sign In with Facebook")
        facebookLoginButton.backgroundColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1)
        self.set(button: emailLoginButton, image: UIImage(named: "ic_email") ?? UIImage(), with: "  Sign In with Email")
    }
    
    @IBAction func loginEmailPress() {
        print("hello!")
        // Nav to home view for now until login w/ email is implemented
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let homeViewController =  storyboard.instantiateViewController(identifier: "homeViewController") as? HomeViewController else {
            assertionFailure("Couldn't find VC")
            return
        }
        
        // Only have home view on stack so user can't go back
        let viewControllers = [homeViewController]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
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
}

