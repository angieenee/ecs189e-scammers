//
//  StockCell.swift
//  CashCow
//
//  Created by Bridget Kelly on 3/8/21.
//

import UIKit
import Toast_Swift

class StockCell: UITableViewCell {
    var user: User?
    var cost: String?
    var currency: String?
    var row: Int?
    
    @IBOutlet weak var stockCode: UILabel!
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var open: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var owned: UILabel!
    
    func configureCell(code: String?, name: String?, price: Float?, open: Float?, high: Float?, low: Float?, currency: String?, row: Int?, user: User?) {
        print("CONFIGURE CELL CALLED------------")
        self.stockCode.text = code
        self.stockName.text = name
        self.price.text = "\(formatMoney(price, currency))"
        self.open.text = "Open: \(formatMoney(open, currency))"
        self.high.text = "High: \(formatMoney(high, currency))"
        self.low.text = "Low: \(formatMoney(low, currency))"
        
        if let cost = price {
            self.cost = String(format: "%.3f", cost)
        }
        self.currency = currency
        self.row = row
        self.user = user
        
        let idx = self.row
        if let i = idx {
            print("LOAD: owns \(self.user?.stocksOwned[i])")
            self.owned.text = "Owned: \(self.user?.stocksOwned[i] ?? 0)"
        }
    }
    
    func formatMoney(_ money: Float?, _ currency: String?) -> String {
        guard let val = money, let curr = currency else {
            return ""
        }
        return String(format: "%.3f", val) + curr
    }
    
    func formatCost(_ price: String?, _ currency: String?) -> [String: Any] {
        let components = price?.components(separatedBy: ".")
        guard let c = currency, let comps = components else {
            return [:]
        }
        return [c: comps[0], asciiShift(str: c, inc: 1, add: false): comps[1]]
    }
    
    @IBAction func buyButtonPressed() {
        // Configure toasts
        var style = ToastStyle()
        style.backgroundColor = .systemGreen
        style.messageColor = .white
        ToastManager.shared.style = style
        ToastManager.shared.isTapToDismissEnabled = true
        
        // Get current row
        
        let cost = self.formatCost(self.cost, self.currency)
        print(cost)
        
        if let key = self.row, let code = self.stockCode.text, let curr = self.currency, let cost = self.cost, let balance = self.user?.money?.balance {
            
            let stockCost = self.getCostMap(cost: cost, currency: curr)
            let validPurchase = self.user?.money?.validSubtraction(balance, stockCost) ?? false
            print("STOCK COST: \(stockCost)")
            if validPurchase {
                self.user?.money?.subtractBalance(stockCost)
                
                if let numberStocksOwned = self.user?.stocksOwned[key] as? Int {
                    self.user?.stocksOwned[key] = numberStocksOwned + 1
                } else {
                    self.user?.stocksOwned[key] = 1
                }
                self.owned.text = "Owned: \(self.user?.stocksOwned[key] ?? 0)"
            
                self.superview?.superview?.makeToast("Bought \(code) stock for \(cost)\(curr)!")
            }
            self.user?.save {
                print("USER SAVED")
                print(self.user?.stocksOwned[key])
            }
        }
    }
    
    @IBAction func sellButtonPressed() {
        // Configure toasts
        var style = ToastStyle()
        style.backgroundColor = .systemGreen
        style.messageColor = .white
        ToastManager.shared.style = style
        ToastManager.shared.isTapToDismissEnabled = true
        
        // Get current row
        
        let cost = self.formatCost(self.cost, self.currency)
        print(cost)
        
        if let key = self.row, let code = self.stockCode.text, let curr = self.currency, let cost = self.cost {
            
            let stockCost = self.getCostMap(cost: cost, currency: curr)
            
            if let numberStocksOwned = self.user?.stocksOwned[key] as? Int {
                if numberStocksOwned > 0 {
                    self.user?.stocksOwned[key] = numberStocksOwned - 1
                    self.superview?.superview?.makeToast("Sold \(code) stock for \(cost)\(curr)!")
                    
                    self.user?.money?.addBalance(stockCost)
                } else {
                    self.superview?.superview?.makeToast("No \(code) stocks to sell.")
                }
            } else {
                self.user?.stocksOwned[key] = 0
                self.superview?.superview?.makeToast("No \(code) stocks to sell.")
            }
            
            self.owned.text = "Owned: \(self.user?.stocksOwned[key] ?? 0)"
            self.user?.save {
                print("USER SAVED")
                print(self.user?.stocksOwned[key])
            }
        }
    }
    
    func getCostMap(cost: String, currency: String) -> [String: Int] {
        let comps = cost.components(separatedBy: ".")
        return [currency: Int(comps[0]) ?? 0, asciiShift(str: currency, inc: 1, add: false): Int(comps[1]) ?? 0]
    }
}
