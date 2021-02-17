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
        
        self.set(button: googleLoginButton, image: UIImage(named: "ic_google") ?? UIImage(), with: " Sign In with Google")
        self.set(button: facebookLoginButton, image: UIImage(named: "ic_facebook") ?? UIImage(), with: " Sign In with Facebook")
        facebookLoginButton.backgroundColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1)
        self.set(button: emailLoginButton, image: UIImage(named: "ic_email") ?? UIImage(), with: " Sign In with Email")
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

