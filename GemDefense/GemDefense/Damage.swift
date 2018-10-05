//
//  Damage.swift
//  GemDefense
//
//  Created by Peter Holko on 2018-01-10.
//  Copyright © 2018 Peter Holko. All rights reserved.
//
import UIKit

class Damage {
    
    func getDamageModifier(damageType: TowerBaseType, armorType: ArmorType) -> CGFloat {
        var damageModifier : CGFloat = 1.0
        
        switch damageType {
        case .Amethyst:
            switch armorType {
            case .Blazed: damageModifier = 0.8
            case .Blue: damageModifier = 0.8
            case .Green: damageModifier = 0.8
            case .Pink: damageModifier = 1.75
            case .Red: damageModifier = 0.8
            case .White: damageModifier = 0.8
            case .Yellow: damageModifier = 0.8
            }
        case .Aquamarine:
            switch armorType {
            case .Blazed: damageModifier = 1.9
            case .Blue: damageModifier = 0.4
            case .Green: damageModifier = 0.7
            case .Pink: damageModifier = 1.0
            case .Red: damageModifier = 1.0
            case .White: damageModifier = 0.8
            case .Yellow: damageModifier = 1.0
            }
        case .Diamond:
            switch armorType {
            case .Blazed: damageModifier = 1.0
            case .Blue: damageModifier = 0.75
            case .Green: damageModifier = 0.6
            case .Pink: damageModifier = 0.2
            case .Red: damageModifier = 1.2
            case .White: damageModifier = 1.6
            case .Yellow: damageModifier = 1.0
            }
        case .Emerald:
            switch armorType {
            case .Blazed: damageModifier = 0.7
            case .Blue: damageModifier = 0.7
            case .Green: damageModifier = 1.7
            case .Pink: damageModifier = 1.5
            case .Red: damageModifier = 0.7
            case .White: damageModifier = 0.7
            case .Yellow: damageModifier = 0.7
            }
        case .Opal:
            switch armorType {
            case .Blazed: damageModifier = 1.9
            case .Blue: damageModifier = 0.4
            case .Green: damageModifier = 0.7
            case .Pink: damageModifier = 1.0
            case .Red: damageModifier = 1.0
            case .White: damageModifier = 0.8
            case .Yellow: damageModifier = 1.0
            }
        case .Ruby:
            switch armorType {
            case .Blazed: damageModifier = 0.8
            case .Blue: damageModifier = 1.0
            case .Green: damageModifier = 0.5
            case .Pink: damageModifier = 0.8
            case .Red: damageModifier = 1.8
            case .White: damageModifier = 1.0
            case .Yellow: damageModifier = 1.0
            }
        case .Sapphire:
            switch armorType {
            case .Blazed: damageModifier = 1.0
            case .Blue: damageModifier = 1.75
            case .Green: damageModifier = 1.0
            case .Pink: damageModifier = 1.0
            case .Red: damageModifier = 1.0
            case .White: damageModifier = 1.0
            case .Yellow: damageModifier = 1.0
            }
        case .Topaz:
            switch armorType {
            case .Blazed: damageModifier = 1.0
            case .Blue: damageModifier = 1.0
            case .Green: damageModifier = 0.7
            case .Pink: damageModifier = 1.2
            case .Red: damageModifier = 0.5
            case .White: damageModifier = 0.6
            case .Yellow: damageModifier = 1.6
            }
        }
        
        return damageModifier
    }
}

