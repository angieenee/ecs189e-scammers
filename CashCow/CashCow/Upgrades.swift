//
//  Upgrades.swift
//  CashCow
//
//  Created by Angie Ni on 3/1/21.
//

import Foundation
import FirebaseDatabase

class Upgrade {
    var type: String?
    var id: Int?
    var name: String?
    var cost: Int?
    var costCurrency: String?
    var statAmt: Int?
    var statAmtCurrency: String?
    var description: String?
    var iconName: String?
    
    init(data: [String: Any], type: String) {
        self.type = type
        self.id = data["id"] as? Int
        self.name = data["name"] as? String
        self.cost = data["cost"] as? Int
        self.costCurrency = data["costCurrency"] as? String
        self.statAmt = data["statAmt"] as? Int
        self.statAmtCurrency = data["statAmtCurrency"] as? String
        self.description = data["description"] as? String
        self.iconName = data["iconName"] as? String
    }
}

// Retrieve upgrades of given type from Firebase
private func getFirebaseUpgrades(_ type: String, completion: @escaping ([Upgrade]?) -> Void) {
    let ref = Database.database().reference(withPath: "upgrades")
    
    ref.child(type).observe(.value, with: { snapshot in
        var upgradesList: [Upgrade] = []
        for child in snapshot.children {
            let snap = child as? DataSnapshot
            if let data = snap?.value as? [String: Any] {
                upgradesList.append(Upgrade.init(data: data, type: type))
            }
        }
        
        completion(upgradesList)

    })
}

// Retrieve stamina upgrades from Firebase
func getStaminaUpgrades(completion: @escaping ([Upgrade]?) -> Void) {
    getFirebaseUpgrades("stamina") { response in
        if let upgradesList = response {
            completion(upgradesList)
        }
    }
}

// Retrieve clicker upgrades from Firebase
func getClickerUpgrades(completion: @escaping ([Upgrade]?) -> Void) {
    getFirebaseUpgrades("clicker") { response in
        if let upgradesList = response {
            completion(upgradesList)
        }
    }
}

// Retrieve passive upgrades from Firebase
func getPassiveUpgrades(completion: @escaping ([Upgrade]?) -> Void) {
    getFirebaseUpgrades("passive") { response in
        if let upgradesList = response {
            completion(upgradesList)
        }
    }
}
