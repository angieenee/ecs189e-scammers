//
//  CashMooooney.swift
//  CashCow
//
//  Created by Jarod Heng on 2/23/21.
//

import Foundation


class Mooooney {
    /* ***************************
     Class Variables and Constants
     *****************************/
    let NUM_BASE = 1000

    var balance: [String: Int]
    var moneyClick: [String: Int]
    var moneyPassive: [String: Int]?
    var keysBalance: (String, String)
    var keysClick: (String, String)

    init() {
        self.balance = ["_": 0, "A": 0]
        self.moneyClick = ["_": 10, "A": 0]
        self.keysBalance = ("A", "_")
        self.keysClick = ("A", "_")
    }
    
    init(_ money: [String: Any]) {
        self.balance = money["balance"] as? [String: Int] ?? ["hello" : 0]
        self.moneyClick = money["money_click"] as? [String: Int] ?? ["hello" : 0]
        self.moneyPassive = money["money_passive"] as? [String: Int]
        
        let largestKeyBal = money["key_balance"] as? String ?? ""
        let largestKeyClick = money["key_click"] as? String ?? ""
        self.keysBalance = (largestKeyBal, asciiShift(str: largestKeyBal, inc: 1, add: false))
        self.keysClick = (largestKeyClick, asciiShift(str: largestKeyClick, inc: 1, add: false))
    }
    
    /* *********************************
                Class Methods
     ***********************************/
    
    func click() -> String {
        for (key, val) in self.moneyClick {
            if balance[key] == nil {
                self.keysBalance.1 = self.keysBalance.0
                self.keysBalance.0 = key
                balance[key] = 0
            }
            if !checkOverflow(key, val, balance[key] ?? 0) {
                self.balance[key]? += val
            }
        }
        return self.getBalance()
    }
    
    func hasEnoughBalance(_ compareMoney: [String: Int]) -> Bool {
        // Not enough keys in balance
        if compareMoney.count > self.balance.count {
            return false
        }
        // Same number of keys
        if compareMoney.count == self.balance.count {
            return (self.formatMoney(money: compareMoney) <= self.getBalance())
        }
        // More keys in balance
        return true
    }
    
    // 1000
    //   -1
    // =999
    func subtractBalance(_ amount: [String: Int]) -> String {
        if self.hasEnoughBalance(amount) {
            var carry = 0
            for (key, val) in amount {
                
            }
        }
        // Remove keys from balance and keysBalance
    }
    
    func addBalance(_ amount: [String: Int]) -> String {
        for (key, val) in amount {
            if balance[key] == nil {
                self.keysBalance.1 = self.keysBalance.0
                self.keysBalance.0 = key
                balance[key] = 0
            }
            if !checkOverflow(key, val, balance[key] ?? 0) {
                self.balance[key]? += val
            }
        }
        return self.getBalance()
    }
    
    func getBalance() -> String {
        return self.formatMoney(money: self.balance)
    }
    
    func getMoneyClick() -> String {
        return self.formatMoney(money: self.moneyClick)
    }
    
    func getMoneyPassive() -> String {
        if let mp = self.moneyPassive {
            return self.formatMoney(money: mp)
        } else {
            return "0.000A"
        }
    }
    
    // Format balance for displaying to user
    func formatMoney(money: [String: Int]) -> String {
        print("Format money: \(money)")
        var amount = ""
        if let d1 = money[self.keysBalance.0], let d2 = money[self.keysBalance.1]{
            let d2_str = String(d2)
            amount += "\(d1)."
            for _ in 0..<(3 - d2_str.count) {
                amount += "0"
            }
            amount += "\(d2)\(self.keysBalance.0)"
        }
        return amount
    }
    
    func checkOverflow(_ key: String, _ clickValue: Int, _ balanceValue: Int) -> Bool {
        // For each element in inventory, if the value is greater than 999, mod by 1000, increment
        var overflow = false
        
        if clickValue + balanceValue >= NUM_BASE {
            let overflowVal = (clickValue + balanceValue) / NUM_BASE
            let leftoverVal = (clickValue + balanceValue) % NUM_BASE
            let newLetter = asciiShift(str: key, inc: 1, add: true)
            
            if self.balance[newLetter] != nil {
                self.balance[newLetter]? += overflowVal
            } else {
                self.keysBalance.1 = self.keysBalance.0
                self.keysBalance.0 = newLetter
                self.balance[newLetter] = overflowVal
            }
            
            self.balance[key] = leftoverVal
            overflow = true
        }
        
        return overflow
    }
    
    
    /* DEBUG FUNCS */
    func printAmt() {
        print(getBalance())
    }
}

// Helper methods to inc/decrement string for balance
func asciiShift(str: String, inc: UInt8, add: Bool) -> String {
    var newStr = ""
    let char = str[str.index(str.startIndex, offsetBy: str.count - 1)]
    
    if add {
        // Adding
        if char == "Z" {
            // TODO: modify to handle multiple Z's
            return "AA"
        }
        if char == "_" {
            return "A"
        }
        if let asciiVal = char.asciiValue {
            newStr = String(UnicodeScalar(asciiVal + inc))
        }

    } else {
        // Subtracting
        if str == "A" {
            return "_"
        }
        if let asciiVal = char.asciiValue {
            newStr = String(UnicodeScalar(asciiVal - inc))
        }
    }
    
    return newStr
}
