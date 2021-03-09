//
//  StockCell.swift
//  CashCow
//
//  Created by Bridget Kelly on 3/8/21.
//

import UIKit

class StockCell: UITableViewCell {
    @IBOutlet weak var stockCode: UILabel!
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var open: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var buyButton: UIButton!

    func configureCell(code: String, name: String, price: String, open: String, high: String, low: String) {
        self.stockCode.text = code
        self.stockName.text = name
        self.price.text = "$\(price)"
        self.open.text = "Open: $\(open)"
        self.high.text = "High: $\(high)"
        self.low.text = "Low: $\(low)"
    }
    
}
