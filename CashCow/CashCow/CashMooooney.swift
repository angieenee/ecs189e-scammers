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
    var largestVal: String
    var secondVal: String

    init() {
        self.balance = ["_": 0, "A": 0]
        self.moneyClick = ["_": 100]
        self.largestVal = "A"
        self.secondVal = "_"
    }
    
    init(balance: [String: Int], click: [String: Int], passive: [String: Int], largest: String) {
        self.balance = balance
        self.moneyClick = click
        self.moneyPassive = passive
        self.largestVal = largest
        self.secondVal = asciiShift(str: largest, inc: 1, add: false)
    }
    
    /* *********************************
                Class Methods
     ***********************************/
    
    func click() -> String {
        for (key, val) in self.moneyClick {
            if !checkOverflow(key, val, balance[key] ?? 0) {
                self.balance[key]? += val
            }
        }
        return getBalance()
    }
    
    // Format balance for displaying to user
    func getBalance() -> String {
        var amount = ""
        if let d1 = self.balance[self.largestVal], let d2 = self.balance[self.secondVal]{
            let d2_str = String(d2)
            amount += "\(d1)."
            if d2_str.count < 3 {
                for _ in 0..<(3 - d2_str.count) {
                    amount += "0"
                }
            }
            amount += "\(d2)\(self.largestVal)"
        }
        return amount
    }
    
    func checkOverflow(_ key: String, _ clickValue: Int, _ balanceValue: Int) -> Bool {
        // TODO: for each element in inventory, if the value is greater than 999, mod by 1000, increment
        var overflow = false
        
        if clickValue + balanceValue >= NUM_BASE {
            let overflowVal = (clickValue + balanceValue) / NUM_BASE
            let leftoverVal = (clickValue + balanceValue) % NUM_BASE
            let newLetter = asciiShift(str: key, inc: 1, add: true)
            
            if self.balance[newLetter] != nil {
                self.balance[newLetter]? += overflowVal
            } else {
                self.secondVal = self.largestVal
                self.largestVal = newLetter
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
//        if char == "Z" {
//            return
//        }
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
