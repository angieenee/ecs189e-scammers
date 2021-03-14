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
//        print("INIT CALLED: ")
//        print(money)
        self.balance = money["balance"] as? [String: Int] ?? [:]
        self.moneyClick = money["money_click"] as? [String: Int] ?? [:]
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
            if self.balance[key] == nil {
                self.keysBalance.1 = self.keysBalance.0
                self.keysBalance.0 = key
                self.balance[key] = 0
            }
            if !checkOverflow(key, val, self.balance[key] ?? 0) {
                self.balance[key]? += val
            }
        }
        return self.getBalance()
    }
    
    func hasEnoughBalance(_ compareMoney: [String: Int]) -> Bool {
        // First, check keys of balance and compareMoney
        var temp_key = "_"
        while (self.balance[temp_key] != nil && compareMoney[temp_key] != nil) {
            temp_key = asciiShift(str: temp_key, inc: 1, add: true)
        }
        if (self.balance[temp_key] == nil && compareMoney[temp_key] == nil) {
            return self.getBalance() >= formatMoney(compareMoney)
        }
        if (self.balance[temp_key] != nil) {
            return true
        }
        return false
    }
    
    func validSubtraction(_ balance: [String: Int], _ cost: [String: Int]) -> Bool {
        let c_idx = cost.index(cost.startIndex, offsetBy: cost.count - 1)
        
        if self.keysBalance.0 < cost.keys[c_idx] {
            return false
        } else if self.keysBalance.0 == cost.keys[c_idx] {
            print("VALID SUBTRACTION-------")
            print(balance[self.keysBalance.0] ?? 0)
            print(cost.values[c_idx])
            return (balance[self.keysBalance.0] ?? 0) >= cost.values[c_idx]
        } else {
            return true
        }
    }
    
    func addBalance(_ amount: [String: Int]) {
        for (key, val) in amount {
            if self.balance[key] == nil {
                self.keysBalance.1 = self.keysBalance.0
                self.keysBalance.0 = key
                self.balance[key] = 0
            }
            if !checkOverflow(key, val, balance[key] ?? 0) {
                self.balance[key]? += val
            }
        }
    }
    
    func subtractBalance(_ amount: [String: Int]) {
        print(amount)
        self.balance = self.subtract(self.balance, amount)
    }
    
    // Generalized Add
    func add(_ amt1: [String: Int], _ amt2: [String: Int]) -> [String: Int] {
        var sum = amt1
        var carry = 0
        for (key, val1) in sum {
            if let val2 = amt2[key] {
                if val1 + val2 + carry  >= NUM_BASE {
                    sum[key] = (val1 + val2 + carry) - NUM_BASE
                    carry = (val1 + val2 + carry) / NUM_BASE
                }
                else {
                    sum[key] = val1 + val2 + carry
                    carry = 0
                }
            }
        }
        return sum
    }
    
    func subtract(_ amt1: [String: Int], _ amt2: [String: Int]) -> [String: Int] {
        var diff = amt1
        for (key, val1) in diff {
            if let val2 = amt2[key] {
                if val1 - val2 <= 0 {
                    let underflowVal = (val1 - val2) / NUM_BASE
                    let leftoverVal = (val1 - val2) % NUM_BASE
                    let prevLetter = asciiShift(str: key, inc: 1, add: false)
                    
                    if diff[prevLetter] != nil {
                        diff[prevLetter]? -= underflowVal
                    } else {
                        diff[prevLetter] = underflowVal
                    }
                    diff[key] = leftoverVal
                } else {
                    if val1-val2 >= NUM_BASE {
                        let overflowVal = (val1 + val2) / NUM_BASE
                        let leftoverVal = (val1 + val2) % NUM_BASE
                        let nextLetter = asciiShift(str: key, inc: 1, add: true)
                        
                        if diff[nextLetter] != nil {
                            diff[nextLetter]? += overflowVal
                        } else {
                            diff[nextLetter] = overflowVal
                        }
                        diff[key] = leftoverVal
                    } else {
                        diff[key] = val1 - val2
                    }
                }
            }
        }
        print("DIFF: \(diff)")
        return diff
    }
    
    func getBalance() -> String {
        return self.formatMoney(self.balance)
    }
    
    func getMoneyClick() -> String {
        return self.formatMoney(self.moneyClick)
    }
    
    func getMoneyPassive() -> String {
        if let mp = self.moneyPassive {
            return self.formatMoney(mp)
        } else {
            return "0.000A"
        }
    }
    
    // Format balance for displaying to user
    func formatMoney(_ money: [String: Int]) -> String {
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
