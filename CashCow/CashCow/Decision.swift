//
//  Decision.swift
//  CashCow
//
//  Created by Angie Ni on 3/7/21.
//

import Foundation

struct Decision: Codable {
    var id: Int
    var name: String
    var description: String
    var numOptions: Int
    
    // ex: Balance ["balance": ["subtract: ["_": 100, "A": 1]]
    var option1change: [String: [String: [String: Int]]]?
    var option2change: [String: [String: [String: Int]]]?
    var option3change: [String: [String: [String: Int]]]?
    
    var option1text: String?
    var option2text: String?
    var option3text: String?
    
}
