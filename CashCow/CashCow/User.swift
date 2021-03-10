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
    var upgrades: [String: Int]? // upgrade type: id
    var staminaRegen: [String: Int]?
    var date: [String: Any]?
    var stocks: [[String: Any]]?
    var stocksOwned: [String: Any] = [:]
    
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
            if let stocksOwned = data["stocks_owned"] as? [String: Any] {
                self.stocksOwned = stocksOwned
            } else {
                for i in 0..<stocks.count {
                    stocksOwned[String(i)] = 0
                }
            }
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
                        "stocks_owned": stocksOwned] as [String : Any]
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
    
    //    func push_decision(completion: () -> Void) {
    //        let ref1 = Database.database().reference(withPath: "decisions")
    //        let post = [
    //            [
    //                "id": 0,
    //                "name": "Dinner Dash",
    //                "description": "Hungry from the clicking? It’s time to refuel!",
    //                "nameA": "MooDash Delivery",
    //                "nameB": "Cook At Home",
    //                "typeA": "stamina",
    //                "typeB": "clicker",
    //                "amountA": 5,
    //                "amountB": 5,
    //                "keyA": "A",
    //                "keyB": "A"
    //            ],
    //            [
    //                "id": 1,
    //                "name": "Stimoolus Check",
    //                "description": "Cowngress sent you a stimoolus check! What shall we do with it?",
    //                "nameA": "Cash It In",
    //                "nameB": "Stash As Savings",
    //                "typeA": "balance",
    //                "typeB": "passive",
    //                "amountA": 100,
    //                "amountB": 10,
    //                "keyA": "A",
    //                "keyB": "A"
    //            ],
    //            [
    //                "id": 2,
    //                "name": "Free Time",
    //                "description": "Take a break from the clicking. How should we relax?",
    //                "nameA": "MooTube Video",
    //                "nameB": "Call Moom",
    //                "typeA": "clicker",
    //                "typeB": "passive",
    //                "amountA": 5,
    //                "amountB": 5,
    //                "keyA": "A",
    //                "keyB": "A"
    //            ],
    //            [
    //                "id": 3,
    //                "name": "Aerobic Cowrdio",
    //                "description": "30 minutes of exercise a day gives the clickers a good pay!",
    //                "nameA": "Home Workout",
    //                "nameB": "Gym Membership",
    //                "typeA": "passive",
    //                "typeB": "stamina",
    //                "amountA": 10,
    //                "amountB": 10,
    //                "keyA": "A",
    //                "keyB": "A"
    //            ]
    //        ]
    //        ref1.child().setValue(post) {
    //            (error: Error?, ref: DatabaseReference) in
    //            if let error = error {
    //                print("Data could not be saved: \(error).")
    //            } else {
    //                print("Data saved successfully!")
    //            }
    //        }
    //    }
}
