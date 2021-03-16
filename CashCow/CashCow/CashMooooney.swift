//
//  CashMooooney.swift
//  CashCow
//
//  Created by Jarod Heng on 2/23/21.
//
import Foundation
/* for use in checking the order of the associated nums, helpful for determining what the highest nonzzeroletter is
enum LetterOrder: Int {
    case A = 1,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z
}
*/

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
        // Add money per click to user balance
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
    
    // Check if balance is less or greater than compareMoney
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
    
    // Check is cost is less or greater than balance
    func validSubtraction(_ balance: [String: Int], _ cost: [String: Int]) -> Bool {
        let c_idx = cost.index(cost.startIndex, offsetBy: cost.count - 1)
        
        print("self.keysBalance.0 -- ", self.keysBalance.0)
        print("cost.keys[c_idx] -- ", cost.keys[c_idx])
        print("balance[self.keysBalance.0] -- ", balance[self.keysBalance.0] ?? -1)
        print("cost.values[c_idx] -- ", cost.values[c_idx])
        
        if self.keysBalance.0 < cost.keys[c_idx] {
            print("FALSE -- self.keysBalance.0 < cost.keys[c_idx]")
            return false
        } else if self.keysBalance.0 == cost.keys[c_idx] {
            print("FALSE -- self.keysBalance.0 == cost.keys[c_idx]")
            return (balance[self.keysBalance.0] ?? 0) >= cost.values[c_idx]
        } else {
            print("TRUE BITCH")
            return true
        }
    }
    
    // Add amount to balance
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
    
    // Subtract amount from balance
    func subtractBalance(_ amount: [String: Int]) {
        print(amount)
        self.balance = self.subtract(self.balance, amount)
    }
    
    // General add method
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
                    
    // General subtract method
    func subtract(_ amt1: [String: Int], _ amt2: [String: Int]) -> [String: Int] {
        var diff = amt1
        
        for (key, val1) in diff {
            if let val2 = amt2[key] {
                if val1 - val2 < 0 {
                    let underflowVal = abs(Int(floor(Double(val1 - val2) / Double(NUM_BASE))))
                    let leftoverVal = (val1 - val2) % NUM_BASE
                    let nextLetter = asciiShift(str: key, inc: 1, add: false)
                    
                    if diff[nextLetter] != nil {
                        diff[nextLetter]? -= underflowVal
                    } else {
                        // should throw an error or crash bc this aint it chief
                        diff[nextLetter] = -underflowVal
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

        return diff
    }
    
    // Get user balance formatted for display
    func getBalance() -> String {
        return self.formatMoney(self.balance)
    }
    
    // Get user money/click formatted for display
    func getMoneyClick() -> String {
        return self.formatMoney(self.moneyClick)
    }
    
    // Get user money/second formatted for display
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
    
    // Check overflow (clickValue + balanceValue >= NUM_BASE = 1000)
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
}

// Helper method to inc/decrement string for balance
func asciiShift(str: String, inc: UInt8, add: Bool) -> String {
    var newStr = ""
    let char = str[str.index(str.startIndex, offsetBy: str.count - 1)]
    
    if add {
        // Adding
        if char == "Z" {
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
