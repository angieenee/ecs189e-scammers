//
//  Decision.swift
//  CashCow
//
//  Created by Angie Ni on 3/7/21.
//

import Foundation

// Choose A or B decision
class Decision {
    var id: Int?
    var name: String?   // alert name
    var description: String?
    // var frequency: Int? // weight
    var nameA: String?  // for action text
    var nameB: String?
    var typeA: String?  // balance, stamina, passive, clicker
    var typeB: String?
    var amountA: Int?
    var amountB: Int?
    var keyA: String?
    var keyB: String?
    
    init(data: [String: Any], type: String) {
        self.id = data["id"] as? Int
        self.name = data["name"] as? String
        self.description = data["description"] as? String
        self.frequency = data["frequency"] as? Int
        self.nameA = data["nameA"] as? String
        self.nameB = data["nameB"] as? String
        self.typeA = data["typeA"] as? String
        self.typeB = data["typeB"] as? String
        self.amountA = data["amountA"] as? Int
        self.amountB = data["amountB"] as? Int
        self.keyA = data["keyA"] as? String
        self.keyB = data["keyB"] as? String
    }
}
