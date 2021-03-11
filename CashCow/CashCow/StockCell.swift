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
    var indexPath: IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        return superView.indexPath(for: self)
    }
    var cost: String?
    var currency: String?
    
    @IBOutlet weak var stockCode: UILabel!
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var open: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var owned: UILabel!
    
    func configureCell(code: String?, name: String?, price: Float?, open: Float?, high: Float?, low: Float?, currency: String?, user: User?) {
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
        self.user = user
        
        let idx = self.indexPath?.row
        if let i = idx {
            self.owned.text = "Owned: \(self.user?.stocksOwned[String(i)] ?? "0")"
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
        print(components)
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
        let ip = self.indexPath
        print("ROW: \(ip?.row)")
        
        let cost = self.formatCost(self.cost, self.currency)
        print(cost)
        
        if let key = ip?.row {
            if let numberStocksOwned = self.user?.stocksOwned[String(key)] as? Int{
                self.user?.stocksOwned[String(key)] = numberStocksOwned + 1
            } else {
                self.user?.stocksOwned[String(key)] = 1
            }
            
            print("USER OWNS: \(self.user?.stocksOwned)")
            
            self.superview?.superview?.makeToast("Bought stock!")
            (self.superview?.superview as? StocksViewController)?.user = self.user
            self.user?.save {
                print("USER SAVED")
                print(self.user?.stocksOwned[String(key)])
                self.owned.text = "Owned: \(self.user?.stocksOwned[String(key)] ?? "0")"
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
        let ip = self.indexPath
        print("ROW: \(ip?.row)")
        
        let cost = self.formatCost(self.cost, self.currency)
        print(cost)
        
        if let key = ip?.row {
            if let numberStocksOwned = self.user?.stocksOwned[String(key)] as? Int {
                print("Stocks number: \(numberStocksOwned)")
                if numberStocksOwned > 0 {
                    self.user?.stocksOwned[String(key)] = numberStocksOwned - 1
                    self.superview?.superview?.makeToast("Sold stock!")
                } else {
                    self.superview?.superview?.makeToast("No stocks to sell.")
                }
            } else {
                self.user?.stocksOwned[String(key)] = 0
                self.superview?.superview?.makeToast("No stocks to sell.")
            }
        }
    }
}
