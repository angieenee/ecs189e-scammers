//
//  CashMooooney.swift
//  CashCow
//
//  Created by Jarod Heng on 2/23/21.
//

import Foundation

// maybe use enums to represent number of each letter in a container/array?
// can have the 'letter' be an array of MooneyLetters for extensibility
// or useful for code readibility in accessing the array of uint8s
enum MooneyLetter : Int {
    case Num = 0, A = 1, B, C, D, E, F, G, H, I, J, AA, AB, AC, AD, AE, AF, AG, AH, AI, AJ
}


// this option just keeps inventory of Letters (1000000s)

    /*
    var A: Int
    var B: Int
    var C: Int
    var D: Int
    var E: Int
    var F: Int
    var G: Int
    var H: Int
    var I: Int
    var J: Int
    */
    
    // the idea is
    
    // array of uint16s, denoting how many of each letter owned
    // var inventory: [UInt16] = []


class Mooooney {
    /* ***************************
     Class Variables and Constants
     *****************************/
    let NUM_BASE = 1000
    
    // NOTE: use LETTER_VALS.capacity for future capacity upgrade related stuff?
    /*
    let LETTER_VALS: [Int:String] = [0: "", 1:"A", 2:"B", 3:"C", 4:"D", 5:"E", 6:"F", 7:"G", 8:"H", 9:"I", 10:"J",
                                     11: "AA", 12: "AB", 13: "AC", 14: "AD", 15: "AE", 16: "AF", 17: "AG", 18: "AH", 19: "AI", 20: "AJ",
                                     21: "BA", 22: "BB", 23: "BC", 24: "BD", 25: "BE", 26: "BF", 27: "BG", 28: "BH", 29: "BI", 30: "BJ", ]
     */
    let LETTER_VALS: [String] = ["","A","B","C","D","E","F","G","H","I","J",
                                     "AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ",
                                     "BA","BB","BC","BD","BE","BF","BG","BH","BI","BJ" ]
    
    // String to hold the display amount
    var amount: String
    
    // index 0 holds the 1000s place, up to 999, index 1 holds As, idx 2 holds Bs and so on\
    // inventory.count-1 is the highest letter, possible hold as separate member var for easy retrieval
    var inventory: [Int16] = [0]
    // var letter: [MooneyLetter] = []

    init() {
        self.amount = ""
        inventory = [0]
    }
    
    // blindly trust that we're being fed aproper array of int16s
    init(cash: [Int16]) {
        self.amount = ""
        self.inventory = cash
        self.fmtAmount()
    }
    
    /* *********************************
                Class Methods
     ***********************************/
    func addMooney(cash: [Int16]) {
        let oldMoney = self.inventory
        // TODO: for each element, add the corresponding element
        self.checkOverflow()
    }
    
    func subtractMooney(cash: [Int16]) {
        // TODO: for each element, add the corresponding element
        self.checkOverflow()
    }
    
    /*
    func increaseNumberBy(x: Int) {
        let remainder = x % NUM_BASE
        let letter = x/NUM_BASE
    }
    */
 
    func fmtAmount() {
        // highest letter . second highest letter, both formatted to 3 characters
        // example 934.111B = 934B + 111A
        // self.amount = "highestnum.2ndhighestnum HighestNonzeroLetter)"
        let predecimal = inventory[inventory.count-1]
        // TODO: if there isnt an inventory.count-2 default to 000
        let postdecimal = inventory[inventory.count-2] ?? 0
        // TODO: format based on number of numbers for postdecimal (24 -> 024)
        let postdecimalstr = "\(postdecimal)"
        self.amount = "\(predecimal).\(postdecimalstr)\(LETTER_VALS[self.inventory.count-1])"
    }
    
    func getAmount() -> String {
        return amount
    }
    
    func checkOverflow() {
        // TODO: for each element in inventory, if the value is greater than 999, mod by 1000, increment
    }
    
    
    
    
    /* DEBUG FUNCS */
    func printAmt() {
        print(self.amount)
    }
    
    func testAdd1() {
        // inventory[MooneyLetter.Num]
        inventory[0] += 1
        self.checkOverflow()
    }
    
}
