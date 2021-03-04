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
    
    func load(_ data: [String: Any], completion: () -> Void) {
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
    
    func save(completion: () -> Void) {
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
            }
        }
    }
}
