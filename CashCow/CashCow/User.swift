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
    
    func push_decision(completion: () -> Void) {
        let ref1 = Database.database().reference(withPath: "upgrades")
        let post = [
            ["id": 0,
            "name": "Coffee Udders",
            "cost": 10,
            "costCurrency": "A",
            "statAmt": 10,
            "statAmtCurrency": "A",
            "description": "Ah! Calf-feine really keeps me awake! This upgrade makes stamina regenerate X% faster.",
            "iconName": "coffee"],
            ["id": 1,
            "name": "Barn Remoodeling",
            "cost": 50,
            "costCurrency": "A",
            "statAmt": 50,
            "statAmtCurrency": "A",
            "description": "Let’s ask Old MacDonald for some marble counters and a king size moottress -- that should refresh stamina X% faster!",
            "iconName": "tools"],
            ["id": 2,
            "name": "Spa and Moossage Day",
            "cost": 100,
            "costCurrency": "A",
            "statAmt": 100,
            "statAmtCurrency": "A",
            "description": "My mooscles are so tense… a trip to the Moossage Parlor would boost stamina regeneration by X%!",
            "iconName": "handSparkles"]
        ] as [[String : Any]]
        ref1.child("stamina").setValue(post) {
            (error: Error?, ref: DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("****Data saved successfully to Firebase!")
            }
        }
    }
    
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
                        "key_click": m.keysClick.0] as [String : Any]
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
}
