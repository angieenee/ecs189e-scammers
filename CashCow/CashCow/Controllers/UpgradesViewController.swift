//
//  UpgradesViewController.swift
//  CashCow
//
//  Created by Rachel Quan on 2/21/21.
//

import UIKit
import FontAwesome_swift
import Toast_Swift

class UpgradesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: User?
    
    var progressUpdateAfterUpgrade: Float?
    
    var categoryOn = "stamina"
    
    @IBOutlet weak var backButton: UIButton!
        
    @IBOutlet weak var upgradesTable: UITableView!
    
    @IBOutlet weak var staminaIcon: UIButton!
    @IBOutlet weak var clickerIcon: UIButton!
    @IBOutlet weak var passiveIncomeIcon: UIButton!
        
    @IBOutlet weak var staminaLabel: UILabel!
    @IBOutlet weak var clickerLabel: UILabel!
    @IBOutlet weak var passiveIncomeLabel: UILabel!
    
    var categoryIcons: [UIButton] = []
    var categoryTextLabels: [UILabel] = []
    
    var upgradesList: [Upgrade] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure toasts
        var style = ToastStyle()
        style.backgroundColor = .systemYellow
        style.messageColor = .white
        ToastManager.shared.style = style
        ToastManager.shared.isTapToDismissEnabled = true
        
        self.upgradesTable.dataSource = self
        self.upgradesTable.delegate = self
        
        self.categoryIcons.append(staminaIcon)
        self.categoryIcons.append(clickerIcon)
        self.categoryIcons.append(passiveIncomeIcon)
        
        self.categoryTextLabels.append(staminaLabel)
        self.categoryTextLabels.append(clickerLabel)
        self.categoryTextLabels.append(passiveIncomeLabel)
        
        self.staminaIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        self.staminaIcon.setTitle(String.fontAwesomeIcon(name: .heartbeat), for: .normal)
        
        self.categoryIcons[0].setTitleColor(.systemRed, for: .normal)
        self.categoryTextLabels[0].textColor = .systemRed
        
        self.clickerIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        self.clickerIcon.setTitle(String.fontAwesomeIcon(name: .handPointUp), for: .normal)
        
        self.passiveIncomeIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        self.passiveIncomeIcon.setTitle(String.fontAwesomeIcon(name: .coins), for: .normal)
        
        getStaminaUpgrades() { response in
            if let upgrades = response {
                self.upgradesList = upgrades
                self.upgradesTable.reloadData()
            }
        }
    }
    
    // TableView Protocols Implementation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.upgradesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UpgradeCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "upgradeCell") as? UpgradeCell {
            cell = reuseCell
            reuseCell.buyButton.backgroundColor = UIColor.systemGreen
            reuseCell.buyButton.isEnabled = true
        } else {
            cell = UpgradeCell(style: .default, reuseIdentifier: "upgradeCell")
        }
        
        cell.user = self.user
        cell.progressUpdateAfterUpgrade = self.progressUpdateAfterUpgrade
        cell.upgrades = self.upgradesList
        cell.configureCell(category: self.categoryOn, row: indexPath.row)
                
        return cell
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let clickerViewController =  storyboard.instantiateViewController(identifier: "clickerViewController") as? ClickerViewController else {
            assertionFailure("Couldn't find Profile VC")
            return
        }
        clickerViewController.user = self.user
        
        clickerViewController.progressUpdateAfterUpgrade = self.progressUpdateAfterUpgrade
        
        
        // Push to stack because we want users to be able to go back to clicker view
        let viewControllers = [clickerViewController]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }

    
    func resetCategoriesButtons() {
        self.categoryIcons = self.categoryIcons.map ({
            $0.setTitleColor(.systemBlue, for: .normal); return $0
        })
        self.categoryTextLabels = self.categoryTextLabels.map ({
            $0.textColor = .black; return $0
        })
    }
    
    @IBAction func staminaButtonPressed(_ sender: Any) {
        resetCategoriesButtons()
        
        self.categoryOn = "stamina"
        
        self.categoryIcons[0].setTitleColor(.systemRed, for: .normal)
        self.categoryTextLabels[0].textColor = .systemRed
        
        getStaminaUpgrades() { response in
            if let upgrades = response {
                self.upgradesList = upgrades
                self.upgradesTable.reloadData()
            }
        }
    }
    
    @IBAction func clickerButtonPressed(_ sender: Any) {
        resetCategoriesButtons()
        
        self.categoryOn = "clicker"
        
        self.categoryIcons[1].setTitleColor(.systemRed, for: .normal)
        self.categoryTextLabels[1].textColor = .systemRed
        
        getClickerUpgrades() { response in
            if let upgrades = response {
                self.upgradesList = upgrades
                self.upgradesTable.reloadData()
            }
        }
    }
    
    @IBAction func passiveIncomePressed(_ sender: Any) {
        resetCategoriesButtons()
        
        self.categoryOn = "passive"
        
        self.categoryIcons[2].setTitleColor(.systemRed, for: .normal)
        self.categoryTextLabels[2].textColor = .systemRed
        
        getPassiveUpgrades() { response in
            if let upgrades = response {
                self.upgradesList = upgrades
                self.upgradesTable.reloadData()
            }
        }
    }
    
    
}
