//
//  Upgrades.swift
//  CashCow
//
//  Created by Angie Ni on 3/1/21.
//

import Foundation

class Stats {
    var staminaGeneration: int
    var passiveMooney: int
    var mooneyPerClick: int
}

class Upgrade {
    var upgradeType: String // 'stamina', 'passive', or 'perclick"
    var upgradeQuantity: int 
}
