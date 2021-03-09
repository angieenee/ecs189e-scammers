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
    @IBOutlet weak var sellButton: UIButton!

    func configureCell(code: String?, name: String?, price: Float?, open: Float?, high: Float?, low: Float?, currency: String?) {
        self.stockCode.text = code
        self.stockName.text = name
        self.price.text = "\(formatMoney(price, currency))"
        self.open.text = "Open: \(formatMoney(open, currency))"
        self.high.text = "High: \(formatMoney(high, currency))"
        self.low.text = "Low: \(formatMoney(low, currency))"
    }
    
    func formatMoney(_ money: Float?, _ currency: String?) -> String {
        guard let val = money, let curr = currency else {
            return ""
        }
        return String(format: "%.3f", val) + curr
    }
    
}
