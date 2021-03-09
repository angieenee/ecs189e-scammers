//
//  UpgradeCell.swift
//  CashCow
//
//  Created by Bridget Kelly on 3/8/21.
//

import UIKit

class UpgradeCell: UITableViewCell {
    
    @IBOutlet weak var upgradeIcon: UIButton!
    @IBOutlet weak var upgradeName: UILabel!
    @IBOutlet weak var upgradeAmt: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var upgradeDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
