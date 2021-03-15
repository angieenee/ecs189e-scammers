//
//  InfoPopupViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 3/15/21.
//

import UIKit

class InfoPopupViewController: UIViewController {

    @IBOutlet weak var instructionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        instructionsLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In laoreet efficitur neque. Etiam aliquam eros tellus, eget dictum mi iaculis vitae. Aliquam et pharetra ex. Proin non dui maximus lorem aliquam pulvinar. Nunc mi sapien, mollis semper risus at, blandit convallis tortor. Aenean ornare, mi dignissim congue suscipit, nisi mi rutrum ipsum, a blandit sapien libero ac enim. Aliquam et egestas neque, vel commodo nunc. Morbi consectetur velit vel congue egestas. Duis elementum lectus justo, ac lobortis purus ultricies sit amet. Maecenas finibus pulvinar dui. Etiam porta gravida auctor."
    }
    
    @IBAction func tapToDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
