//
//  Upgrades.swift
//  CashCow
//
//  Created by Angie Ni on 3/1/21.
//

import Foundation

struct Upgrade: Codable {
    var type: String? // 'stamina', 'passive', or 'perclick"
    var name: String?
    var cost: Int?
    var costCurrency: String?
    var statAmt: Int?
    var statAmtCurrency: String?
    var description: String?
    var iconName: String?
}

func readLocalFile() -> Data? {
    do {
        guard let bundlePath = Bundle.main.path(forResource: "UpgradesList",
                                                ofType: "json") else {
            print("BUNDLE PATH NOT FOUND")
            return nil
        }
        print("bundle path---------", bundlePath)
        
        if let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
//            print(jsonData)
            print("DO")
            return jsonData
        }
    } catch {
        print("BAD")
        print(error)
    }
    
    print("nil")
    
    return nil
}

func parseData() {
    if let localData = readLocalFile() {
        print("UPGRADES PARSING----")
//        do {
//            let upgradeData = try JSONDecoder().decode(Upgrade.self, from: localData)
//        } catch  {
//            print("ERROR IN DECODING UPGRADE DATA")
//        }
        
        do {
            let results = try JSONDecoder().decode([Upgrade].self, from: localData)
            print("RESULTS--------")
            print(results)
        } catch  {
            print("ERROR IN DECODING UPGRADE list------")
        }
        
        

        
    }
}
