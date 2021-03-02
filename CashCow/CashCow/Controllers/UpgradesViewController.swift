//
//  UpgradesViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/21/21.
//

import UIKit
import FontAwesome_swift

//class UpgradeCell: UITableViewCell {
//    @IBOutlet weak var upgradeIcon: UIButton!
//
//    @IBOutlet weak var upgradeName: UILabel!
//
//    @IBOutlet weak var upgradeAmount: UILabel!
//
//    @IBOutlet weak var upgradeDescription: UILabel!
//
//    @IBOutlet weak var buyButton: UIButton!
//
//}

class UpgradesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: User?
    
    @IBOutlet weak var backButton: UIButton!
        
    @IBOutlet weak var upgradesTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.upgradesTable.dataSource = self
        self.upgradesTable.delegate = self
        
    }
    
    // TableView Protocols Implementation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: return size of upgrades array
        // upgrades array will be a list of upgrades object
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Populate each row for each upgrades object
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "upgradesTableCell") as? UpgradeCell else {
//            assertionFailure("upgradesTableCell dequeue error")
//            return UITableViewCell.init()
//        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "upgradesTableCell") else {
            assertionFailure("upgradesTableCell dequeue error")
            return UITableViewCell.init()
        }
        
//        cell.upgradeIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
//        cell.upgradeIcon.setTitle(String.fontAwesomeIcon(name: .coffee), for: .normal)
//        
//        cell.upgradeName.text = "Coffee"
//        
//        cell.upgradeAmount.text = "$3a"
//        
//        cell.upgradeDescription.text = "Lorem ipsum"
                
        return cell
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
