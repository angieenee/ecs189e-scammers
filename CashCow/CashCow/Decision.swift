//
//  Decision.swift
//  CashCow
//
//  Created by Angie Ni on 3/7/21.
//

import Foundation

class Decision {
    var id: Int?
    var name: String?
    var description: String?
    var numOptions: Int?
    
    // ex: Balance ["balance": ["subtract: ["_": 100, "A": 1]]
    var option1change: [String: [String: [String: Int]]]?
    var option2change: [String: [String: [String: Int]]]?
    var option3change: [String: [String: [String: Int]]]?
    
    var option1text: String?
    var option2text: String?
    var option3text: String?
    
    init(data: [String: Any], type: String) {
        self.id = data["id"] as? Int
        self.name = data["name"] as? String
        self.description = data["description"] as? String
        self.numOptions = data["numOptions"] as? Int
        self.option1change = data["option1change"] as? [String: [String: [String: Int]]]
        self.option2change = data["option2change"] as? [String: [String: [String: Int]]]
        self.option3change = data["option3change"] as? [String: [String: [String: Int]]]
        self.option1text = data["option1text"] as? String
        self.option2text = data["option2text"] as? String
        self.option3text = data["option3text"] as? String
    }
}
