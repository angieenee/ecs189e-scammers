//
//  User.swift
//  CashCow
//
//  Created by Bridget Kelly on 2/23/21.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class User {
    var ref = Database.database().reference(withPath: "users")
    var firebaseAuth = Auth.auth()
    
    var email: String?
    var uid: String?
    var username: String?
    var money: Mooooney?
    var upgrades: [String: [Int]] = [:] // upgrade type: id
    var staminaRegen: [String: Int]?
    var date: [String: Any]?
    var stocks: [[String: Any]]?
    var stocksOwned: [Int] = []
    var stamina: Float?
    
    func load(_ data: [String: Any], completion: @escaping () -> Void) {
        self.email = data["email"] as? String
        self.uid = firebaseAuth.currentUser?.uid
        self.money = Mooooney.init(data)
        
        if let username =  data["username"] as? String {
            self.username = username
        } else {
            if let email = self.email, let i = self.email?.firstIndex(of: "@") {
                self.username = String(email[..<i])
            }
        }
        if let date = data["date"] as? [String: Any] {
            self.date = date
        }
        if let stocks = data["stocks"] as? [[String: Any]] {
            self.stocks = stocks
            if let stocksOwned = data["stocks_owned"] as? [Int] {
                self.stocksOwned = stocksOwned
            } else {
                for _ in 0..<stocks.count {
                    self.stocksOwned.append(0)
                }
            }
        }
        if let upgrades = data["upgrades"] as? [String: [Int]] {
            self.upgrades = upgrades
            if (self.upgrades["stamina"] == nil) {
                self.upgrades["stamina"] = []
            }
            if (self.upgrades["clicker"] == nil) {
                self.upgrades["clicker"] = []
            }
            if (self.upgrades["passive"] == nil) {
                self.upgrades["passive"] = []
            }
        } else {
            upgrades["stamina"] = []
            upgrades["clicker"] = []
            upgrades["passive"] = []
        }
        if let stamina = data["stamina"] as? Float {
            self.stamina = stamina
        }
        
        completion()
    }
    
    func save(completion: @escaping () -> Void) {
        if let uid = Auth.auth().currentUser?.uid, let m = self.money {
            let post = ["email": email,
                        "username": username,
                        "balance": m.balance,
                        "money_click": m.moneyClick,
                        "money_passive": m.moneyPassive,
                        "key_balance": m.keysBalance.0,
                        "key_click": m.keysClick.0,
                        "date": date,
                        "stocks": stocks,
                        "stocks_owned": stocksOwned,
                        "upgrades": upgrades,
                        "stamina": stamina] as [String : Any]
            ref.child(uid).setValue(post) {
                (error: Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data saved successfully!")
                }
                completion()
            }
        }
    }
//
//    func push_decision(completion: () -> Void) {
//        let ref1 = Database.database().reference(withPath: "decisions")
//        let post = [ [
//            "description" : "Hungry from the clicking? It’s time to refuel!",
//            "id" : 0,
//            "name" : "Dinner Dash",
//            "numOptions": 3,
//            "option1text" : "MooDash Delivery",
//            "option2text" : "Home cooked meal",
//            "option3text": "Takeout",
//            "option1change": ["balance": ["subtract": ["_": 0, "A": 10]]],
//            "option2change": ["stamina": ["subtract": ["_": 100, "A": 0]]],
//            "option3change": ["balance": ["subtract": ["_": 0, "A": 5]], "stamina": ["subtract": ["_": 50, "A": 0]]]
//          ], [
//            "description" : "Cowngress sent you a stimoolus check! What shall we do with it?",
//            "id" : 1,
//            "name" : "Stimoolus Check",
//            "numOptions": 2,
//            "option1text" : "Cash It In",
//            "option2text" : "Stash As Savings",
//            "option1change": ["balance": ["add": ["_": 0, "A": 5]]],
//            "option2change": ["passive": ["add": ["_": 500, "A": 0]]]
//          ], [
//            "description" : "A friend is going through a rough patch and asks if you could pay for this month’s rent.",
//            "id" : 2,
//            "name" : "A Favor",
//            "numOptions": 3,
//            "option1text" : "Help them",
//            "option2text" : "Don't help",
//            "option3text" : "Make them a GoFundMoo",
//            "option1change": ["balance": ["subtract": ["_": 0, "A": 30]], "passive": ["add": ["_": 0, "A": 5]]],
//            "option2change": [],
//            "option3change": ["stamina": ["subtract": ["_": 100, "A": 0]], "passive": ["add": ["_": 0, "A": 1]]]
//          ], [
//            "description" : "OUCH! I clicked too hard and strained my mooscles.",
//            "id" : 3,
//            "name" : "Hurt At Work",
//            "numOptions": 2,
//            "option1text" : "Visit the doctor",
//            "option2text" : "Nothing a bandage can't fix",
//            "option1change": ["balance": ["subtract": ["_": 0, "A": 30]], "clicker": ["add": ["_": 500, "A": 0]]],
//            "option2change": ["clicker": ["subtract": ["_": 500, "A": 0]]]
//          ], [
//              "description" : "It's been a while since we took a day off...",
//              "id" : 4,
//              "name" : "Paid Time Off",
//              "numOptions": 3,
//              "option1text" : "Take a personal day",
//              "option2text" : "End work early",
//              "option3text" : "Save your sick day",
//              "option1change": ["stamina": ["add": ["_": 100, "A": 0]]],
//              "option2change": ["stamina": ["add": ["_": 50, "A": 0]], "clicker": ["add": ["_": 0, "A": 5]]],
//              "option3change": ["clicker": ["add": ["_": 0, "A": 10]]]
//          ], [
//              "description" : "Cash in some money now or keep waiting? Liquidate some assets now.",
//              "id" : 5,
//              "name" : "Spend or Save?",
//              "numOptions": 2,
//              "option1text" : "",
//              "option2text" : "",
//              "option1change": [],
//              "option2change": []
//          ] ]
//        ref1.setValue(post) {
//            (error: Error?, ref: DatabaseReference) in
//            if let error = error {
//                print("Data could not be saved: \(error).")
//            } else {
//                print("Data saved successfully!")
//            }
//        }
//    }
        
    func isUpgradeAlreadyBought(_ type: String, _ id: Int) -> Bool {
        guard let upgradeTypeList = self.upgrades[type] else {
//            print("upgrades[type] does not exist")
            return false
        }
        
//        print("TYPE -- \(type)")
//        for indiv_id in upgradeTypeList {
//            print(" ID -- \(indiv_id)")
//        }
        
        let filteredUpgrades = upgradeTypeList.filter{ $0 == id}
        
        return !filteredUpgrades.isEmpty
    }
}
