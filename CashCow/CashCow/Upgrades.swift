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

private func readJSONFile() -> Data? {
    do {
        guard let bundlePath = Bundle.main.path(forResource: "UpgradesList", ofType: "json") else {
            print("BUNDLE PATH NOT FOUND")
            return nil
        }
        print("bundle path---------", bundlePath)
        
        if let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
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

private func parseUpgradeData() -> [Upgrade]? {
    if let localData = readJSONFile() {
        print("UPGRADES PARSING----")
        
        do {
            let upgradesList = try JSONDecoder().decode([Upgrade].self, from: localData)
            print("RESULTS--------")
            print(upgradesList)
            return upgradesList
        } catch  {
            print("ERROR IN DECODING UPGRADE list------")
        }
            
    }

    print("Empty")
    return nil
}

func getStaminaUpgrades() -> [Upgrade]? {
    guard let upgradesList = parseUpgradeData() else {
        print("Unable to parse upgrade data")
        return nil
    }
    
  return upgradesList.filter{$0.type == "stamina"}
}

func getClickerUpgrades() -> [Upgrade]? {
    guard let upgradesList = parseUpgradeData() else {
        print("Unable to parse upgrade data")
        return nil
    }
    
  return upgradesList.filter{$0.type == "clicker"}
}

func getPassiveUpgrades() -> [Upgrade]? {
    guard let upgradesList = parseUpgradeData() else {
        print("Unable to parse upgrade data")
        return nil
    }
    
  return upgradesList.filter{$0.type == "passive"}
}
