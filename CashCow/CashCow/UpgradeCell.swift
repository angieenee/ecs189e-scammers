//
//  UpgradeCell.swift
//  CashCow
//
//  Created by Bridget Kelly on 3/8/21.
//

import UIKit
import FontAwesome_swift

class UpgradeCell: UITableViewCell {
    
    @IBOutlet weak var upgradeIcon: UIButton!
    @IBOutlet weak var upgradeName: UILabel!
    @IBOutlet weak var upgradeAmt: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var upgradeDescription: UILabel!

    func configureCell(upgradesList: [Upgrade], row: Int) {
        let iconName = upgradesList[row].iconName ?? "default"
        self.upgradeIcon.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        self.upgradeIcon.setTitle(String.fontAwesomeIcon(name: self.convertStringToFontAwesome(iconName)), for: .normal)

        self.upgradeName.text = upgradesList[row].name

        let upgradeCost = upgradesList[row].cost ?? -1

        let upgradeCostCurrency = upgradesList[row].costCurrency ?? "A"

        self.upgradeAmt.text = String(upgradeCost) + upgradeCostCurrency

        self.upgradeDescription.text = upgradesList[row].description
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
        default:
            return .allergies
        }
    }
    
}
