//
//  UpgradeCell.swift
//  CashCow
//
//  Created by Bridget Kelly on 3/8/21.
//

import UIKit
import FontAwesome_swift
import Toast_Swift

class UpgradeCell: UITableViewCell {
    
    var user: User?
    var upgrades: [Upgrade]?
    var progressUpdateAfterUpgrade: Float?
    
    @IBOutlet weak var upgradeIcon: UIButton!
    @IBOutlet weak var upgradeName: UILabel!
    @IBOutlet weak var upgradeAmt: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var upgradeDescription: UILabel!
    
    var indexPath: IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        return superView.indexPath(for: self)
    }

    func configureCell(category: String, row: Int) {
        guard let upgradesList = self.upgrades else {
            return
        }
        let iconName = upgradesList[row].iconName ?? "default"
        self.upgradeIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        self.upgradeIcon.setTitle(String.fontAwesomeIcon(name: self.convertStringToFontAwesome(iconName)), for: .normal)

        self.upgradeName.text = upgradesList[row].name

        let upgradeCost = upgradesList[row].cost ?? -1

        let upgradeCostCurrency = upgradesList[row].costCurrency ?? "A"

        self.upgradeAmt.text = String(upgradeCost) + upgradeCostCurrency

        self.upgradeDescription.text = upgradesList[row].description
        
        // if this upgrade cell is found in upgrades list
            // turn buy button color to gray
        dump(self.user?.upgrades)

        
        let isBuyButtonGray = self.user?.isUpgradeAlreadyBought(category, row) ?? false
        
        if (isBuyButtonGray) {
            self.buyButton.backgroundColor = UIColor.systemGray
            self.buyButton.isEnabled = false
        }
    }
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        guard let upgradesList = self.upgrades else {
            return
        }
        
        // Check if user has enough mooney for upgrade
        guard let index = self.indexPath?.row else {
            return
        }
        let upgrade = upgradesList[index]
        var upgradeExpense: [String: Int]
        
        if let key = upgrade.costCurrency, let val = upgrade.cost, let type = upgrade.type, let id = upgrade.id, let statAmt = upgrade.statAmt, let statCurrency = upgrade.statAmtCurrency, let currBalance = self.user?.money?.balance  {
            upgradeExpense = [key: val]
            if let validPurchase = self.user?.money?.validSubtraction(currBalance, upgradeExpense) {
                if validPurchase {
                    self.user?.money?.subtractBalance(upgradeExpense)
                    self.user?.upgrades[type]?.append(id)
                 
                    // Put upgrade into effect:
                    var formattedStats: [String: Int]
                    formattedStats = [statCurrency: statAmt]
                    
                    
                    if type == "stamina" {
                        progressUpdateAfterUpgrade =
                            Float((statAmt / 100))
                        
                        self.superview?.superview?.makeToast("Successfully bought stamina upgrade.", duration: 3.0, position: .top)
                    }
                    
                    if type == "passive" {
                        self.user?.money?.moneyPassive = user?.money?.add(user?.money?.moneyPassive ?? ["_": 0, "A": 0], formattedStats)
                        
                        self.superview?.superview?.makeToast("Successfully bought passive upgrade.", duration: 3.0, position: .top)
                    }
                    
                    if type == "clicker" {
                        self.user?.money?.moneyClick = user?.money?.add(user?.money?.moneyClick ?? ["_": 0, "A": 0], formattedStats) ?? ["_": 0, "A": 0]
                        
                        self.superview?.superview?.makeToast("Successfully bought clicker upgrade.", duration: 3.0, position: .top)
                    }
                    
                    self.user?.save {
                        guard let superView = self.superview as? UITableView else {
                            print("superview is not a UITableView - getIndexPath")
                            return
                        }
                        
                        superView.reloadData()
                        print("Save completed")
                    }
                }
                else {
                    self.superview?.superview?.makeToast("Not enough moooney for this upgrade.", duration: 3.0, position: .top)
                }
            }
        }
    }
    
    func convertStringToFontAwesome(_ iconName: String) -> FontAwesome {
        switch iconName {
        case "coffee":
            return .coffee
        case "shoePrints":
            return .shoePrints
        case "dumbbell":
            return .dumbbell
        case "tools":
            return .tools
        case "handSparkles":
            return .handSparkles
        case "hatCowboySide":
            return .hatCowboySide
        case "briefcase":
            return .briefcase
        case "moneyBillWave":
            return .moneyBillWave
        case "longArrowAltUp":
            return .longArrowAltUp
        case "utensils":
            return .utensils
        case "hamburger":
            return .hamburger
        case "conciergeBell":
            return .conciergeBell
        case "home":
            return .home
        case "leaf":
            return .leaf
        case "breadSlice":
            return .breadSlice
        default:
            return .allergies
        }
    }
    
}
