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
    var email: String?
    var uid: String?
    var username: String?
    var money: Mooooney?
    
    func save() {
        // persist to DB
    }
}
