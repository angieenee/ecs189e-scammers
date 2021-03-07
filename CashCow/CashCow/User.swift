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
    var upgrades: [String: [Int]]? // upgrade type: id
    
    func push_upgrades(completion: () -> Void) {
        var ref1 = Database.database().reference(withPath: "upgrades")
        let post = ["id": 0,
                    "name": "Hoof Shine",
                    "cost": 10,
                    "costCurrency": "A",
                    "statAmt": 10,
                    "statAmtCurrency": "A",
                    "description": "Can’t click well if your hooves aren’t spruced up! This upgrade +10A more mooney to each click!",
                    "iconName": "shoePrints"] as [String : Any]
        ref1.child("clicker").setValue(post) {
            (error: Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
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
