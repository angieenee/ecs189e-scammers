//
//  UpgradesViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/21/21.
//

import UIKit
import FontAwesome_swift

class UpgradeCell: UITableViewCell {
    @IBOutlet weak var upgradeIcon: UIButton!
    
    @IBOutlet weak var upgradeName: UILabel!
    
    @IBOutlet weak var upgradeAmt: UILabel!
    
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var upgradeDescription: UILabel!
}

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "upgradesTableCell") as! UpgradeCell
        

        cell.upgradeIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cell.upgradeIcon.setTitle(String.fontAwesomeIcon(name: .coffee), for: .normal)
        
        cell.upgradeName.text = "Coffee Udders"
        
        cell.upgradeAmt.text = "100A"
        
        cell.upgradeDescription.text = "Ah! Calf-feine really keeps me awake! This upgrade makes stamina regenerate 5% faster."
                
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
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        // TODO: Implement this button
        print("PRESSED")
    }
}
