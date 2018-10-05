//
//  Tower.swift
//  GemDefense
//
//  Created by Peter Holko on 2016-05-21.
//  Copyright © 2016 Peter Holko. All rights reserved.
//

import Foundation
import SpriteKit

let BASE_RANGE = 2000.0
let BASE_COOLDOWN = 1.0
let BASE_PROJECTILE_SPEED = 2000.0

enum TowerBaseType : String {
    case Amethyst, Aquamarine, Diamond, Emerald, Opal, Ruby, Sapphire, Topaz
}

enum TowerQuality : String {
    case Chipped, Flawed, Normal, Flawless, Perfect, Great
}

enum TowerType : String {
    case Rock, Standard, BlackOpal, MysticBlackOpal, BloodStone, AncientBloodStone, DarkEmerald,
    EnchantedEmerald, Gold, EgyptianGold, Jade, AsianJade, LuckyAsianJade, Malachite, 
    VividMalachite, MightyMalachite, Paraiba, ParaibaTourmalineFacet, PinkDiamond, 
    GreatPinkDiamond, RedCrystal, RedCrystalFacet, RoseQuartzCrystal, Silver, SterlingSilver,
    SilverKnight, StarRuby, BloodStar, FireStar, Uranium235, Uranium238, YellowSapphire, 
    StarYellowSapphire, UberStone
}


class Tower : SKSpriteNode {
    var game : GameScene!
    var selectSprite = SKSpriteNode(imageNamed: "select")
    
    var id : Int = -1
    
    var towerBaseType : TowerBaseType = .Amethyst
    var towerType : TowerType = .Standard
    var towerQuality : TowerQuality = .Chipped
    var towerLevel = 0
    var attacking = true
    var towerPlacedThisRound = false


    var rangeModifier: Double = 0.0
    var projectileModifier: Double = 1.0
    var cooldownModifier: Double = 1.0

    var damageBase = 1
    var sidesPerDie = 1
    var attackRange = 0
    var projectileSpeed = 500
   
    var multiTargets = 1
    var damageBurn = false
    var attacksGround = true
    var attacksFlying = true
    var critChance = 0.0
    var critMultiplier = 2

    var poisonDuration = 0.0
    var poisonDamage = 0.0
    var poisonSlowModifier = 0.0
    
    var speedAuraValue = 0.0
    var damageAuraValue = 0.0

    var bonusAura = false
    var speedAuraOpalValue = 0.00
    var speedAuraOpalRange = 0

    var aoe = false
    var aoeFreeze = false
    var aoeRange = 0
    
    var armorPenalty = false
    var armorPenaltyValue = 0.0
    var armorPenaltyDuration = 0.0
    
    var stunPossible = false
    var stunChance = 0.0
    var stunDuration = 0.0

    var iceSlow = false
    var iceSlowModifier = 0.0

    var proxAuraFlying = false
    var proxAuraArmorPenalty = 0.0
    var proxAuraSpeedPenalty = 0.0
    var proxAuraRange = 0
    var proxAuraGround = true
    
    var damageAuraSpecialValue = 0.0
    var damageAuraSpecialRange = 0
    
    var crit = false
    
    var selected : Bool = false

    var numKills = 0
    var upgradeCost = 0
    var upgradesTo = TowerType.Rock
    
    var towerName : String = "Rock"
    var info = "Unknown"
    
    var tileX : Int = 0
    var tileY : Int = 0
  
    var targets: [Enemy] = [Enemy]()
    
    init() {
        let texture = SKTexture(imageNamed: "rock")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func randomTower() {
        resetAbilities()
        
        randomType()
        randomQuality()
        setTowerName()
        setAttributes()
        
        changeTower(towerType, quality: towerQuality)
    }
    
    func resetAbilities() {
        
        attacking = true
        towerPlacedThisRound = false
        attacksFlying = true
        attacksGround = true
    
        rangeModifier = 0.0
        projectileModifier = 1.0
        cooldownModifier = 1.0
    
        damageBase = 1
        sidesPerDie = 1
        attackRange = 0
        projectileSpeed = 500
        
        multiTargets = 1
        damageBurn = false
        critChance = 0.0
        critMultiplier = 2
    
        poisonDuration = 0.0
        poisonDamage = 0.0
        poisonSlowModifier = 0.0
        
        speedAuraValue = 0.0
        damageAuraValue = 0.0
    
        bonusAura = false
        speedAuraOpalValue = 0.0
        speedAuraOpalRange = 0
    
        aoe = false
        aoeFreeze = false
        aoeRange = 0
    
        armorPenalty = false
        armorPenaltyValue = 0
        armorPenaltyDuration = 0
    
        stunPossible = false
        stunChance = 0.0
        stunDuration = 0.0
    
        iceSlow = false
        iceSlowModifier = 0.0
    
        proxAuraFlying = false
        proxAuraArmorPenalty = 0.0
        proxAuraSpeedPenalty = 0.0
        proxAuraRange = 0
        proxAuraGround = true
    
        damageAuraSpecialValue = 0.0
        damageAuraSpecialRange = 0
    }
    
    func randomType() {
        let randomType = random(min: 0, max: 96)
    
        if(randomType >= 0 && randomType < 12) {
            towerBaseType = TowerBaseType.Amethyst
        } else if(randomType >= 12 && randomType < 24) {
            towerBaseType = TowerBaseType.Aquamarine
        } else if(randomType >= 24 && randomType < 36) {
            towerBaseType = TowerBaseType.Diamond
        } else if(randomType >= 36 && randomType < 48) {
            towerBaseType = TowerBaseType.Emerald
        } else if(randomType >= 48 && randomType < 60) {
            towerBaseType = TowerBaseType.Opal
        } else if(randomType >= 60 && randomType < 72) {
            towerBaseType = TowerBaseType.Ruby
        } else if(randomType >= 72 && randomType < 84) {
            towerBaseType = TowerBaseType.Sapphire
        } else if(randomType >= 84 && randomType < 96) {
            towerBaseType = TowerBaseType.Topaz
        }
    }
    
    func randomQuality() {
        let randomQuality = random(min: 0, max: 99)

        if(qualityLevel == 0) {
            towerQuality = .Chipped            
        } else if(qualityLevel == 1) {
            if(randomQuality >= 0 && randomQuality < 70) {
                towerQuality = .Chipped
            } else {
                towerQuality = .Flawed
            }
        } else if(qualityLevel == 2) {
            if(randomQuality >= 0 && randomQuality < 60) {
                towerQuality = .Chipped
            } else if(randomQuality >= 60 && randomQuality < 90) {
                towerQuality = .Flawed
            } else if(randomQuality >= 90 && randomQuality <= 99) {
                towerQuality = .Normal
            }
        } else if(qualityLevel == 3) {
            if(randomQuality >= 0 && randomQuality < 50) {
                towerQuality = .Chipped
            } else if(randomQuality >= 50 && randomQuality < 80) {
                towerQuality = .Flawed
            } else if(randomQuality >= 80 && randomQuality <= 99) {
                towerQuality = .Normal
            }

        } else if(qualityLevel == 4) {
            if(randomQuality >= 0 && randomQuality < 40) {
                towerQuality = .Chipped
            } else if(randomQuality >= 40 && randomQuality < 70) {
                towerQuality = .Flawed
            } else if(randomQuality >= 70 && randomQuality < 90) {
                towerQuality = .Normal
            } else if(randomQuality >= 90 && randomQuality < 99) {
                towerQuality = .Flawless
            }           
        } else if(qualityLevel == 5) {
            if(randomQuality >= 0 && randomQuality < 30) {
                towerQuality = .Chipped
            } else if(randomQuality >= 30 && randomQuality < 60) {
                towerQuality = .Flawed
            } else if(randomQuality >= 60 && randomQuality < 90) {
                towerQuality = .Normal
            } else if(randomQuality >= 90 && randomQuality < 99) {
                towerQuality = .Flawless
            }           
        } else if(qualityLevel == 6) {
            if(randomQuality >= 0 && randomQuality < 20) {
                towerQuality = .Chipped
            } else if(randomQuality >= 20 && randomQuality < 50) {
                towerQuality = .Flawed
            } else if(randomQuality >= 50 && randomQuality < 80) {
                towerQuality = .Normal
            } else if(randomQuality >= 80 && randomQuality < 99) {
                towerQuality = .Flawless
            }            
        } else if(qualityLevel == 7) {
            if(randomQuality >= 0 && randomQuality < 10) {
                towerQuality = .Chipped
            } else if(randomQuality >= 10 && randomQuality < 40) {
                towerQuality = .Flawed
            } else if(randomQuality >= 40 && randomQuality < 70) {
                towerQuality = .Normal
            } else if(randomQuality >= 70 && randomQuality < 99) {
                towerQuality = .Flawless
            }
        } else if(qualityLevel == 8) {
            if(randomQuality >= 0 && randomQuality < 30) {
                towerQuality = .Flawed
            } else if(randomQuality >= 30 && randomQuality < 60) {
                towerQuality = .Normal
            } else if(randomQuality >= 60 && randomQuality < 90) {
                towerQuality = .Flawless
            } else if(randomQuality >= 90 && randomQuality < 99) {
                towerQuality = .Perfect
            }
        }
    }
    
    func setTowerName() {
        switch(towerType) {
            case .Rock:
                towerName = towerType.rawValue
            case .Standard:
                towerName = towerQuality.rawValue + " " + towerBaseType.rawValue
            default:
                towerName = towerType.rawValue
        }
    }
    
    func setSelectSprite() {
        selectSprite.isHidden = false
        selectSprite.anchorPoint = CGPoint(x: 0, y: 0)
        selectSprite.position = CGPoint(x: -5, y: -5)
        selectSprite.zPosition = 1
        addChild(selectSprite)
    }
    
    func setSelect(selectStatus: Bool) {
        selected = selectStatus
        
        if selected {
            selectSprite.isHidden = false
        }
        else {
            selectSprite.isHidden = true
        }
    }
    
    func increaseQuality() {
        if towerQuality == .Chipped {
            towerQuality = .Flawed
        } else if towerQuality == .Flawed {
            towerQuality = .Normal
        } else if towerQuality == .Normal {
            towerQuality = .Flawless
        } else if towerQuality == .Flawless {
            towerQuality = .Perfect
        } else if towerQuality == .Perfect {
            towerQuality = .Great
        }
    }
    
    func changeTower(_ type: TowerType, quality: TowerQuality) {
        resetAbilities()
        
        towerType = type
        towerQuality = quality
        
        setTowerName()
        setAttributes()
        
        changeSprite()
    }
    
    func changeSprite() {
        let spriteName = towerName.replacingOccurrences(of: " ", with: "").lowercased()
        texture = SKTexture(imageNamed: spriteName)
    }
    
    func attackEnemy() {
        let wait = SKAction.wait(forDuration: calculateFireRate())
        let run = SKAction.run {
            
            if self.game.flyingLevel {
                if self.attacksFlying {
                    if self.damageBurn {
                        self.damageBurnEnemy()
                    } else {
                        self.shootWeapon()
                    }
                }
            } else {
                if self.attacksGround {
                    if self.damageBurn {
                        self.damageBurnEnemy()
                    } else {
                        self.shootWeapon()
                    }
                }
            }
        }

        self.run(SKAction.repeatForever(SKAction.sequence([wait, run])), withKey: "attack")
    }

    func attackStop() {
        self.removeAction(forKey: "attack")
    }

    func shootWeapon() {
        for target in targets {
            createProjectile(target)
        }
    }
    
    func damageBurnEnemy() {
        for target in targets {
            let calculateDamage = self.calculateDamage(enemy: target)
            
            target.setDamage(damage: calculateDamage)
            target.setHpBar()
        }
    }

    func createProjectile(_ enemy: Enemy) {
        print("Create Projectile")
        let projectileImage = ("projectile_" + towerBaseType.rawValue).lowercased()
        let projectileSprite = SKSpriteNode(imageNamed:projectileImage)
        
        let sourcePos = CGPoint(x: self.position.x + projectileSprite.size.width / 2,
                                          y: self.position.y + projectileSprite.size.height / 2)

        let timeToTarget = getTimeToPoint(sourcePos, targetPos: enemy.position, travelSpeed: projectileSpeed)

        projectileSprite.position =  sourcePos
        projectileSprite.zPosition = 1
        
        let actionMove = SKAction.move(to: enemy.position, duration: timeToTarget)
        let actionMoveDone = SKAction.removeFromParent()
        let actionDamageEnemy = SKAction.run {
            
            //Apply any effects
            self.applyEffects(enemy: enemy)
            
            //Calculate damage
            let calculatedDamage : Int = self.calculateDamage(enemy: enemy)
            
            //Draw crit damage
            if(self.crit) {
                self.crit = false
                self.game.drawCrit(critDamage: calculatedDamage, enemyPos: enemy.position)
            }
        
            //Check if tower has aoe damage
            if self.aoeRange > 0 {
                self.game.aoeDamage(sourcePos: enemy.position,
                                    aoeRange: self.aoeRange,
                                    aoeDamage: calculatedDamage,
                                    iceSlowModifier: self.iceSlowModifier)
            } else {
                //Set damage and hp bar
                enemy.setDamage(damage: calculatedDamage)
                enemy.setHpBar()
            }
        }

        projectileSprite.run(SKAction.sequence([actionMove, actionMoveDone, actionDamageEnemy]))
        
        self.parent?.addChild(projectileSprite)
    }
    
    func applyEffects(enemy: Enemy) {
        
        if(self.iceSlowModifier > 0) {
            enemy.applyIceSlow(modifier: self.iceSlowModifier)
        }
        
        if(self.poisonSlowModifier > 0) {
            enemy.applyPoison(modifier: self.poisonSlowModifier, damage: self.poisonDamage, duration: self.poisonDuration)
        }
        
        if(self.stunPossible) {
            let stunRoll = random(min: 1, max: 100)
            
            if stunRoll <= CGFloat(self.stunChance * 100) {
                enemy.applyStun(duration: self.stunDuration)
            }
        }
        
        if(self.armorPenalty) {
            enemy.applyArmorPenalty(penalty: self.armorPenaltyValue, duration: self.armorPenaltyDuration)
        }
    }
    
    func calculateDamage(enemy: Enemy) -> Int {
        let enemyArmor = enemy.armor - Int(enemy.armorPenaltyValue) + self.game.armorLevel
        
        let armorTypeModifier = self.game.armorTable.getArmorModifier(armorValue: enemyArmor)
        let damageTypeModifier = self.game.damageTable.getDamageModifier(damageType: self.towerBaseType, armorType: enemy.armorType)
        
        let damageRoll = random(min: 1, max: CGFloat(sidesPerDie))
        var damage = damageRoll + CGFloat(damageBase)
        damage = damage * CGFloat(armorTypeModifier) * CGFloat(damageTypeModifier)
        
        if critChance > 0 {
            let critRoll = random(min: 1, max: 100)
            let chance = CGFloat(critChance * 100)
            
            if critRoll <= chance {
                crit = true
                damage = damage * CGFloat(critMultiplier)
            }
        }
        
        return Int(damage)
    }

    func calculateFireRate() -> Double {
        return (1.0 * cooldownModifier) - (1.0 * cooldownModifier * speedAuraOpalValue)
    }

    func calculateRange() -> Double {
        return 286 * rangeModifier
    }
    
    func calculateDamageLowRange() -> Double {
         return Double(damageBase) * Double(1 + towerLevel / 10) * Double(1 + damageAuraValue);
    }
    
    func calculateDamageHighRange() -> Double {
        return Double(damageBase + sidesPerDie) * Double(1 + towerLevel / 10) * Double(1 + damageAuraValue);
    }

    func calculateProjectileSpeed() -> Int {
        projectileSpeed = projectileSpeed * Int(projectileModifier);
        return projectileSpeed
    }
    
    func getInfoBox() -> String {
        var infoText = ""
        
        if towerType == .Rock {
            return "Rock"
        }
        
        infoText += "\(towerName) \n"
        infoText += "Damage: \(calculateDamageLowRange()) - \(calculateDamageHighRange()) \n"
        infoText += "Cooldown: \(calculateFireRate()) \n"
        infoText += "Range: \(calculateRange()) \n"
        infoText += "Level: \(towerLevel) \n"
        infoText += "Upgrade Cost: \(upgradeCost) \n"
        infoText += "\(info)"
        
        return infoText
    }

    func getTimeToPoint(_ sourcePos: CGPoint, targetPos: CGPoint, travelSpeed: Int) -> Double {
        return sqrt(pow(Double(targetPos.x - sourcePos.x), 2) +
                    pow(Double(targetPos.y - sourcePos.y), 2)) / Double(travelSpeed);
    }

    func setStandardAttributes() {
        
        if(towerBaseType == .Amethyst) {
            if(towerQuality == .Chipped) {
                rangeModifier = 1000 / BASE_RANGE
                cooldownModifier = 0.8 / BASE_COOLDOWN
                projectileModifier = 1200 / BASE_PROJECTILE_SPEED
                damageBase = 8
                sidesPerDie = 5
            } else if(towerQuality == .Flawed) {
                rangeModifier = 1125 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1400 / BASE_PROJECTILE_SPEED
                damageBase = 17
                sidesPerDie = 8
            } else if(towerQuality == .Normal) {
                rangeModifier = 1250 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1500 / BASE_PROJECTILE_SPEED
                damageBase = 29
                sidesPerDie = 11
            } else if(towerQuality == .Flawless) {
                rangeModifier = 1300 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1800 / BASE_PROJECTILE_SPEED
                damageBase = 59
                sidesPerDie = 16
            } else if(towerQuality == .Perfect) {
                rangeModifier = 1500 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1900 / BASE_PROJECTILE_SPEED
                damageBase = 139
                sidesPerDie = 11
            } else if(towerQuality == .Great) {
                rangeModifier = 1650 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1900 / BASE_PROJECTILE_SPEED
                damageBase = 349
                sidesPerDie = 51
            }

            attacksGround = false
            info = "Attacks air only"
        } else if(towerBaseType == .Aquamarine) {
            if(towerQuality == .Chipped) {
                rangeModifier = 350 / BASE_RANGE
                cooldownModifier = 0.35 / BASE_COOLDOWN
                projectileModifier = 1000 / BASE_PROJECTILE_SPEED
                damageBase = 5
                sidesPerDie = 3
            } else if(towerQuality == .Flawed) {
                rangeModifier = 365 / BASE_RANGE
                cooldownModifier = 0.35 / BASE_COOLDOWN
                projectileModifier = 1000 / BASE_PROJECTILE_SPEED
                damageBase = 11
                sidesPerDie = 4
            } else if(towerQuality == .Normal) {
                rangeModifier = 380 / BASE_RANGE
                cooldownModifier = 0.35 / BASE_COOLDOWN
                projectileModifier = 1000 / BASE_PROJECTILE_SPEED
                damageBase = 23
                sidesPerDie = 7
            } else if(towerQuality == .Flawless) {
                rangeModifier = 425 / BASE_RANGE
                cooldownModifier = 0.35 / BASE_COOLDOWN
                projectileModifier = 1000 / BASE_PROJECTILE_SPEED
                damageBase = 47
                sidesPerDie = 8
            } else if(towerQuality == .Perfect) {
                rangeModifier = 550 / BASE_RANGE
                cooldownModifier = 0.35 / BASE_COOLDOWN
                projectileModifier = 1000 / BASE_PROJECTILE_SPEED
                damageBase = 99
                sidesPerDie = 21
            } else if(towerQuality == .Great) {
                rangeModifier = 600 / BASE_RANGE
                cooldownModifier = 0.35 / BASE_COOLDOWN
                projectileModifier = 1000 / BASE_PROJECTILE_SPEED
                damageBase = 279
                sidesPerDie = 1
            }
            
            info = "Fast attack speed"
        } else if(towerBaseType == .Diamond) {
            if(towerQuality == .Chipped) {
                rangeModifier = 500 / BASE_RANGE
                cooldownModifier = 0.8 / BASE_COOLDOWN
                projectileModifier = 900 / BASE_PROJECTILE_SPEED
                damageBase = 7
                sidesPerDie = 5
                critChance = 0.25
                critMultiplier = 2
            } else if(towerQuality == .Flawed) {
                rangeModifier = 550 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 900 / BASE_PROJECTILE_SPEED
                damageBase = 15
                sidesPerDie = 3
                critChance = 0.25
                critMultiplier = 2
            } else if(towerQuality == .Normal) {
                rangeModifier = 600 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 900 / BASE_PROJECTILE_SPEED
                damageBase = 29
                sidesPerDie = 8
                critChance = 0.25
                critMultiplier = 2
            } else if(towerQuality == .Flawless) {
                rangeModifier = 650 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 850 / BASE_PROJECTILE_SPEED
                damageBase = 57
                sidesPerDie = 8
                critChance = 0.25
                critMultiplier = 2
            } else if(towerQuality == .Perfect) {
                rangeModifier = 750 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 900 / BASE_PROJECTILE_SPEED
                damageBase = 139
                sidesPerDie = 11
                critChance = 0.25
                critMultiplier = 2
            } else if(towerQuality == .Great) {
                rangeModifier = 850 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 900 / BASE_PROJECTILE_SPEED
                damageBase = 299
                sidesPerDie = 51
                critChance = 0.25
                critMultiplier = 2
            }

            attacksFlying = false
            info = "Attacks ground only and has \(critChance * 100)% chance to deal x\(critMultiplier)"
        } else if(towerBaseType == .Emerald) {
            if(towerQuality == .Chipped) {
                rangeModifier = 500 / BASE_RANGE
                cooldownModifier = 0.8 / BASE_COOLDOWN
                projectileModifier = 700 / BASE_PROJECTILE_SPEED
                damageBase = 3
                sidesPerDie = 4
                poisonSlowModifier = 0.15
                poisonDuration = 3
                poisonDamage = 2
            } else if(towerQuality == .Flawed) {
                rangeModifier = 550 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 750 / BASE_PROJECTILE_SPEED
                damageBase = 9
                sidesPerDie = 4
                poisonSlowModifier = 0.20
                poisonDuration = 4
                poisonDamage = 3
            } else if(towerQuality == .Normal) {
                rangeModifier = 600 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 700 / BASE_PROJECTILE_SPEED
                damageBase = 14
                sidesPerDie = 11
                poisonSlowModifier = 0.25
                poisonDuration = 5
                poisonDamage = 5
            } else if(towerQuality == .Flawless) {
                rangeModifier = 700 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 700 / BASE_PROJECTILE_SPEED
                damageBase = 29
                sidesPerDie = 9
                poisonSlowModifier = 0.35
                poisonDuration = 6
                poisonDamage = 8
            } else if(towerQuality == .Perfect) {
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 700 / BASE_PROJECTILE_SPEED
                damageBase = 79
                sidesPerDie = 11
                poisonSlowModifier = 0.50
                poisonDuration = 8
                poisonDamage = 16
            } else if(towerQuality == .Great) {
                rangeModifier = 900 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 700 / BASE_PROJECTILE_SPEED
                damageBase = 199
                sidesPerDie = 41
                poisonSlowModifier = 0.75
                poisonDuration = 20
                poisonDamage = 25
            }

            info = "Deals a poison attack that does \(poisonDamage) damage per second, and slows the target's movement by \(poisonSlowModifier * 100)%.  Lasts \(poisonDuration) seconds."
        
        } else if(towerBaseType == .Opal) {
            if(towerQuality == .Chipped) {
                rangeModifier = 600 / BASE_RANGE
                cooldownModifier = 0.8 / BASE_COOLDOWN
                projectileModifier = 600 / BASE_PROJECTILE_SPEED
                damageBase = 4
                sidesPerDie = 1
                bonusAura = true
                speedAuraOpalValue = 0.1
                speedAuraOpalRange = 86
            } else if(towerQuality == .Flawed) {
                rangeModifier = 700 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 800 / BASE_PROJECTILE_SPEED
                damageBase = 9
                sidesPerDie = 1
                bonusAura = true
                speedAuraOpalValue = 0.15
                speedAuraOpalRange = 100
            } else if(towerQuality == .Normal) {
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1000 / BASE_PROJECTILE_SPEED
                damageBase = 19
                sidesPerDie = 1
                bonusAura = true
                speedAuraOpalValue = 0.20
                speedAuraOpalRange = 115
            } else if(towerQuality == .Flawless) {
                rangeModifier = 900 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 900 / BASE_PROJECTILE_SPEED
                damageBase = 39
                sidesPerDie = 1
                bonusAura = true
                speedAuraOpalValue = 0.25
                speedAuraOpalRange = 129
             } else if(towerQuality == .Perfect) {
                rangeModifier = 1000 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1000 / BASE_PROJECTILE_SPEED
                damageBase = 84
                sidesPerDie = 1
                bonusAura = true
                speedAuraOpalValue = 0.35
                speedAuraOpalRange = 143
            } else if(towerQuality == .Great) {
                rangeModifier = 1500 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1200 / BASE_PROJECTILE_SPEED
                damageBase = 179
                sidesPerDie = 1
                bonusAura = true
                speedAuraOpalValue = 0.50
                speedAuraOpalRange = 214
            }

            info = "Gives an aura to other gems within \(speedAuraOpalRange) range which increases their attack speeds by \(speedAuraOpalValue * 100)%"
            
        } else if(towerBaseType == .Ruby) {
            if(towerQuality == .Chipped) {
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1300 / BASE_PROJECTILE_SPEED
                damageBase = 7
                sidesPerDie = 2

                aoe = true
                aoeRange = 25
            } else if(towerQuality == .Flawed) {
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1400 / BASE_PROJECTILE_SPEED
                damageBase = 12
                sidesPerDie = 4
                
                aoe = true
                aoeRange = 25
            } else if(towerQuality == .Normal) {
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1500 / BASE_PROJECTILE_SPEED
                damageBase = 19
                sidesPerDie = 6
                
                aoe = true
                aoeRange = 30
            } else if(towerQuality == .Flawless) {
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1600 / BASE_PROJECTILE_SPEED
                damageBase = 37
                sidesPerDie = 8

                aoe = true
                aoeRange = 30
            } else if(towerQuality == .Perfect) {
                rangeModifier = 900 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1700 / BASE_PROJECTILE_SPEED
                damageBase = 79
                sidesPerDie = 25

                aoe = true
                aoeRange = 30
            } else if(towerQuality == .Great) {
                rangeModifier = 900 / BASE_RANGE
                cooldownModifier = 0.75 / BASE_COOLDOWN
                projectileModifier = 1700 / BASE_PROJECTILE_SPEED
                damageBase = 139
                sidesPerDie = 1

                aoe = true
                aoeRange = 35
            }

            info = "Attacks cause splash damage"

        } else if(towerBaseType == .Sapphire) {
             if(towerQuality == .Chipped) {
                rangeModifier = 500 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1000 / BASE_PROJECTILE_SPEED
                damageBase = 4
                sidesPerDie = 4

                iceSlowModifier = 0.2
                iceSlow = true                
            } else if(towerQuality == .Flawed) {
                rangeModifier = 750 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1300 / BASE_PROJECTILE_SPEED
                damageBase = 9
                sidesPerDie = 4
                
                iceSlowModifier = 0.2
                iceSlow = true
            } else if(towerQuality == .Normal) {
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1300 / BASE_PROJECTILE_SPEED
                damageBase = 15
                sidesPerDie = 6
                
                iceSlowModifier = 0.2
                iceSlow = true
            } else if(towerQuality == .Flawless) {
                rangeModifier = 850 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1200 / BASE_PROJECTILE_SPEED
                damageBase = 29
                sidesPerDie = 11
                
                iceSlowModifier = 0.2
                iceSlow = true
            } else if(towerQuality == .Perfect) {
                rangeModifier = 1400 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1300 / BASE_PROJECTILE_SPEED
                damageBase = 59
                sidesPerDie = 16
                
                iceSlowModifier = 0.2
                iceSlow = true
            } else if(towerQuality == .Great) {
                rangeModifier = 2000 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1900 / BASE_PROJECTILE_SPEED
                damageBase = 199
                sidesPerDie = 1
                
                iceSlowModifier = 0.2
                iceSlow = true
            }
            
            info = "Attacks will slow target's movement speed"             

        } else if(towerBaseType == .Topaz) {
             if(towerQuality == .Chipped) {
                rangeModifier = 500 / BASE_RANGE
                cooldownModifier = 0.8 / BASE_COOLDOWN
                projectileModifier = 900 / BASE_PROJECTILE_SPEED
                damageBase = 3
                sidesPerDie = 1

                multiTargets = 3
            } else if(towerQuality == .Flawed) {
                rangeModifier = 500 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 900 / BASE_PROJECTILE_SPEED
                damageBase = 7
                sidesPerDie = 1
                
                multiTargets = 3
            } else if(towerQuality == .Normal) {
                rangeModifier = 500 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 900 / BASE_PROJECTILE_SPEED
                damageBase = 13
                sidesPerDie = 1
                
                multiTargets = 4
            } else if(towerQuality == .Flawless) {
                rangeModifier = 500 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 900 / BASE_PROJECTILE_SPEED
                damageBase = 24
                sidesPerDie = 1
                
                multiTargets = 4
            } else if(towerQuality == .Perfect) {
                rangeModifier = 600 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 900 / BASE_PROJECTILE_SPEED
                damageBase = 74
                sidesPerDie = 1
                
                multiTargets = 5
            } else if(towerQuality == .Great) {
                rangeModifier = 700 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 900 / BASE_PROJECTILE_SPEED
                damageBase = 249
                sidesPerDie = 1
                
                multiTargets = 7
            }
            
            info = "Attacks multiple targets"
        }
    }
        
    func setAttributes() {
        switch(towerType) {
            case .Rock:
                attackRange = 0
                rangeModifier = 0
                info = "Used for walls or can be removed."
            case .Standard:
                setStandardAttributes()
            case .Silver:
                towerBaseType = .Sapphire
                
                rangeModifier = 550 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1800 / BASE_PROJECTILE_SPEED
                damageBase = 19
                sidesPerDie = 2
                
                aoeFreeze = true
                aoeRange = 36
                iceSlowModifier = 0.20
                iceSlow = true
                
                upgradeCost = 25
                upgradesTo = .SterlingSilver
                
                info = "Attacks will slow targets within splash area."
            case .SterlingSilver:
                towerBaseType = .Sapphire
                
                rangeModifier = 650 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1800 / BASE_PROJECTILE_SPEED
                damageBase = 39
                sidesPerDie = 1
                
                aoeFreeze = true
                aoeRange = 36
                iceSlowModifier = 0.20
                iceSlow = true
                
                upgradeCost = 300
                upgradesTo = .SilverKnight
                
                info = "Attacks will slow targets within splash area."
            case .SilverKnight:
                towerBaseType = .Sapphire
                
                rangeModifier = 750 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1800 / BASE_PROJECTILE_SPEED
                damageBase = 149
                sidesPerDie = 1
                
                aoeFreeze = true
                aoeRange = 36
                iceSlowModifier = 0.20
                iceSlow = true
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = "Attacks will slow targets within splash area"
            case .Malachite:
                towerBaseType = .Emerald
                
                rangeModifier = 750 / BASE_RANGE
                cooldownModifier = 0.35 / BASE_COOLDOWN
                projectileModifier = 1300 / BASE_PROJECTILE_SPEED
                damageBase = 5
                sidesPerDie = 1
                
                multiTargets = 3
                
                upgradeCost = 25
                upgradesTo = .VividMalachite
                info = "Malachite can attack three targets."
            case .VividMalachite:
                towerBaseType = .Emerald
                
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 0.35 / BASE_COOLDOWN
                projectileModifier = 1300 / BASE_PROJECTILE_SPEED
                damageBase = 10
                sidesPerDie = 1
                
                multiTargets = 4
                
                upgradeCost = 280
                upgradesTo = .MightyMalachite
                
                info = "Vivid Malachite can attack three targets."
            case .MightyMalachite:
                towerBaseType = .Emerald
                
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 0.35 / BASE_COOLDOWN
                projectileModifier = 1300 / BASE_PROJECTILE_SPEED
                damageBase = 44
                sidesPerDie = 1
                
                multiTargets = 10
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = "Mighty Malachite can attack three targets."
            case .Jade:
                towerBaseType = .Aquamarine
                
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 0.5 / BASE_COOLDOWN
                projectileModifier = 2000 / BASE_PROJECTILE_SPEED
                damageBase = 29
                sidesPerDie = 6
                
                poisonSlowModifier = 0.50
                poisonDuration = 2
                poisonDamage = 5
                
                upgradeCost = 45
                upgradesTo = .AsianJade
                
                info = "Poison attack deals 5 per second and slows the target enemy's movement by 50%. Lasts 2 seconds."
            case .AsianJade:
                towerBaseType = .Aquamarine
                
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 0.5 / BASE_COOLDOWN
                projectileModifier = 2000 / BASE_PROJECTILE_SPEED
                damageBase = 49
                sidesPerDie = 1
                
                poisonSlowModifier = 0.50
                poisonDuration = 3
                poisonDamage = 10
                
                upgradeCost = 250
                upgradesTo = .LuckyAsianJade
                
                info = "Poison attack deals 10 per second and slows the target enemy's movement by 50%. Lasts 3 seconds."
            case .LuckyAsianJade:
                towerBaseType = .Aquamarine
                
                rangeModifier = 850 / BASE_RANGE
                cooldownModifier = 0.35 / BASE_COOLDOWN
                projectileModifier = 2000 / BASE_PROJECTILE_SPEED
                damageBase = 54
                sidesPerDie = 1
                
                poisonSlowModifier = 0.50
                poisonDuration = 4
                poisonDamage = 10
                
                critChance = 0.05
                critMultiplier = 4
                
                stunPossible = true
                stunChance = 0.01
                stunDuration = 2
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = "Poison attack deals 10 per second and slows the target enemy's movement by 50%. Lasts 4 seconds.  5% chance to deal 4x damage.  1% chance to stun the enemy."
            case .StarRuby:
                towerBaseType = .Ruby
                
                rangeModifier = 265 / BASE_RANGE
                cooldownModifier = 0.25 / BASE_COOLDOWN
                projectileModifier = 700 / BASE_PROJECTILE_SPEED
                damageBase = 10
                sidesPerDie = 1
                
                damageBurn = true
                multiTargets = 10
                
                upgradeCost = 30
                upgradesTo = .BloodStar
                
                info = "Any enemy within \(calculateRange()) range of the Star Ruby will receive 40 damage per second."
            case .BloodStar:
                towerBaseType = .Ruby
                
                rangeModifier = 500 / BASE_RANGE
                cooldownModifier = 0.25 / BASE_COOLDOWN
                projectileModifier = 700 / BASE_PROJECTILE_SPEED
                damageBase = 12
                sidesPerDie = 1
                
                damageBurn = true
                multiTargets = 10
                
                upgradeCost = 290
                upgradesTo = .FireStar
                
                info = "Any enemy within \(calculateRange()) range of the Blood Star will receive 50 damage per second."
            case .FireStar:
                towerBaseType = .Ruby
                
                rangeModifier = 600 / BASE_RANGE
                cooldownModifier = 0.5 / BASE_COOLDOWN
                projectileModifier = 700 / BASE_PROJECTILE_SPEED
                damageBase = 64
                sidesPerDie = 1
                
                damageBurn = true
                multiTargets = 10
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = "Any enemy within \(calculateRange()) range of the Fire Star will receive 100 damage per second."
            case .PinkDiamond:
                towerBaseType = .Diamond
                
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 0.75 / BASE_COOLDOWN
                projectileModifier = 1200 / BASE_PROJECTILE_SPEED
                damageBase = 149
                sidesPerDie = 26
                
                attacksFlying = false
                critChance = 0.1
                critMultiplier = 5
                
                upgradeCost = 175
                upgradesTo = .GreatPinkDiamond
                
                info = "Attacks ground only and has \(critChance * 100) chance to deal x\(critMultiplier) damage."
            case .GreatPinkDiamond:
                towerBaseType = .Diamond
                
                rangeModifier = 850 / BASE_RANGE
                cooldownModifier = 0.65 / BASE_COOLDOWN
                projectileModifier = 1800 / BASE_PROJECTILE_SPEED
                damageBase = 174
                sidesPerDie = 51
                
                attacksFlying = false
                critChance = 0.10
                critMultiplier = 8
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = "Attacks ground only and has \(critChance * 100) chance to deal x\(critMultiplier) damage."
            case .DarkEmerald:
                towerBaseType = .Emerald
                
                rangeModifier = 550 / BASE_RANGE
                cooldownModifier = 0.8 / BASE_COOLDOWN
                projectileModifier = 2000 / BASE_PROJECTILE_SPEED
                damageBase = 89
                sidesPerDie = 61
                
                stunPossible = true
                stunChance = 0.125
                stunDuration = 1
                
                upgradeCost = 250
                upgradesTo = .EnchantedEmerald
                
                info = "Has a 12.5% chance to stun for 1 second per attack"
            case .EnchantedEmerald:
                towerBaseType = .Emerald
                
                rangeModifier = 700 / BASE_RANGE
                cooldownModifier = 0.7 / BASE_COOLDOWN
                projectileModifier = 2000 / BASE_PROJECTILE_SPEED
                damageBase = 98
                sidesPerDie = 102
                
                critChance = 0.15
                critMultiplier = 4
                
                stunPossible = true
                stunChance = 0.15
                stunDuration = 2
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = "Has a 15% chance to stun for 2 seconds per attack"
            case .Gold:
                towerBaseType = .Amethyst
                
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1500 / BASE_PROJECTILE_SPEED
                damageBase = 159
                sidesPerDie = 31
                
                critChance = 0.25
                critMultiplier = 2
                
                armorPenalty = true
                armorPenaltyValue = 5
                armorPenaltyDuration = 5
                
                upgradeCost = 210
                upgradesTo = .EgyptianGold
                
                info = "25% chance to do x2 damage. Applies -5 armor to targets it attacks."
            case .EgyptianGold:
                towerBaseType = .Amethyst
                
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 0.75 / BASE_COOLDOWN
                projectileModifier = 1500 / BASE_PROJECTILE_SPEED
                damageBase = 159
                sidesPerDie = 41
                
                critChance = 0.30
                critMultiplier = 2
                
                armorPenalty = true
                armorPenaltyValue = 8
                armorPenaltyDuration = 5
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = "30% chance to do x2 damage. Applies -8 armor to targets it attacks."
            case .YellowSapphire:
                towerBaseType = .Sapphire
                
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1500 / BASE_PROJECTILE_SPEED
                damageBase = 99
                sidesPerDie = 1
                
                aoeFreeze = true
                aoeRange = 57
                
                iceSlowModifier = 0.20
                iceSlow = true
                
                upgradeCost = 210
                upgradesTo = .StarYellowSapphire
                
                info = "Attacks will slow targets within a huge spash area."
            case .StarYellowSapphire:
                towerBaseType = .Sapphire
                
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 1500 / BASE_PROJECTILE_SPEED
                damageBase = 99
                sidesPerDie = 1
                
                aoeFreeze = true
                aoeRange = 57
                
                iceSlowModifier = 0.20
                iceSlow = true
                
                bonusAura = true
                damageAuraSpecialValue = 0.05
                damageAuraSpecialRange = 171
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = "Attacks will slow targets within a huge spash area and provides 5% damage bonus to nearby towers."
            case .BlackOpal:
                towerBaseType = .Opal
                
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 800 / BASE_PROJECTILE_SPEED
                damageBase = 24
                sidesPerDie = 1
                
                bonusAura = true
                damageAuraSpecialValue = 0.30
                damageAuraSpecialRange = 143
                
                
                upgradeCost = 300
                upgradesTo = .MysticBlackOpal
                
                info = "Gives 30% more damage to towers within \(damageAuraSpecialRange) range."
            case .MysticBlackOpal:
                towerBaseType = .Opal
                
                rangeModifier = 1000 / BASE_RANGE
                cooldownModifier = 1 / BASE_COOLDOWN
                projectileModifier = 800 / BASE_PROJECTILE_SPEED
                damageBase = 49
                sidesPerDie = 1
                
                bonusAura = true
                damageAuraSpecialValue = 0.40
                damageAuraSpecialRange = 171
                
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = "Gives 40% more damage to towers within \(damageAuraSpecialRange) range."
            case .RedCrystal:
                towerBaseType = .Amethyst
                
                rangeModifier = 1300 / BASE_RANGE
                cooldownModifier = 0.8 / BASE_COOLDOWN
                projectileModifier = 2000 / BASE_PROJECTILE_SPEED
                damageBase = 49
                sidesPerDie = 26
                
                attacksGround = false
                
                proxAuraFlying = true
                proxAuraArmorPenalty = 5
                proxAuraRange = 200
                
                upgradeCost = 100
                upgradesTo = .RedCrystalFacet
                
                info = "Gives -4 armor to air units within a large area.  Can only attack air units."
            case .RedCrystalFacet:
                towerBaseType = .Amethyst
                
                rangeModifier = 1400 / BASE_RANGE
                cooldownModifier = 0.8 / BASE_COOLDOWN
                projectileModifier = 2000 / BASE_PROJECTILE_SPEED
                damageBase = 74
                sidesPerDie = 26
                
                attacksGround = false
                
                proxAuraFlying = true
                proxAuraArmorPenalty = 6
                proxAuraRange = 200
                
                upgradeCost = 100
                upgradesTo = .RoseQuartzCrystal
                
                info = "Gives -5 armor to air units within a large area.  Can only attack air units."
            case .RoseQuartzCrystal:
                towerBaseType = .Amethyst
                
                rangeModifier = 1500 / BASE_RANGE
                cooldownModifier = 0.8 / BASE_COOLDOWN
                projectileModifier = 2000 / BASE_PROJECTILE_SPEED
                damageBase = 99
                sidesPerDie = 26
                
                attacksGround = false
                
                proxAuraFlying = true
                proxAuraArmorPenalty = 7
                proxAuraRange = 214
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = "Gives -6 armor to air units within a large area.  Can only attack air units."
            case .Uranium238:
                towerBaseType = .Topaz
                
                rangeModifier = 450 / BASE_RANGE
                cooldownModifier = 0.25 / BASE_COOLDOWN
                projectileModifier = 700 / BASE_PROJECTILE_SPEED
                damageBase = 47
                sidesPerDie = 1
                
                multiTargets = 10
                
                proxAuraGround = true
                proxAuraFlying = true
                proxAuraSpeedPenalty = 0.5
                proxAuraRange = 64
                
                upgradeCost = 190
                upgradesTo = .Uranium235
                
                info = "Any unit within range of uranium is slowed by 50%.  Uranium will burn enemies for 190 damage per second."
            case .Uranium235:
                towerBaseType = .Topaz
                
                rangeModifier = 600 / BASE_RANGE
                cooldownModifier = 0.25 / BASE_COOLDOWN
                projectileModifier = 700 / BASE_PROJECTILE_SPEED
                damageBase = 64
                sidesPerDie = 1
                
                multiTargets = 10
                
                proxAuraGround = true
                proxAuraFlying = true
                proxAuraSpeedPenalty = 0.5
                proxAuraRange = 64
                
                upgradeCost = 190
                upgradesTo = .Uranium235
                
                info = "Any unit within range of uranium is slowed by 50%.  Uranium will burn enemies for 260 damage per second."
            case .BloodStone:
                towerBaseType = .Ruby
                
                rangeModifier = 700 / BASE_RANGE
                cooldownModifier = 0.50 / BASE_COOLDOWN
                projectileModifier = 1500 / BASE_PROJECTILE_SPEED
                damageBase = 67
                sidesPerDie = 1
                
                aoe = true
                aoeRange = 57
                multiTargets = 10
                
                upgradeCost = 310
                upgradesTo = .AncientBloodStone
                
                info = "Does 135 damage per second to nearby enemies and has splash damage."
            case .AncientBloodStone:
                towerBaseType = .Ruby
                
                rangeModifier = 800 / BASE_RANGE
                cooldownModifier = 0.30 / BASE_COOLDOWN
                projectileModifier = 1500 / BASE_PROJECTILE_SPEED
                damageBase = 81
                sidesPerDie = 1
                
                aoe = true
                aoeRange = 87
                multiTargets = 10
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = "Does 290 damage per second to nearby enemies and has splash damage."
            case .Paraiba:
                towerBaseType = .Aquamarine
                
                rangeModifier = 850 / BASE_RANGE
                cooldownModifier = 0.75 / BASE_COOLDOWN
                projectileModifier = 1750 / BASE_PROJECTILE_SPEED
                damageBase = 25
                sidesPerDie = 80
                
                upgradeCost = 350
                upgradesTo = .ParaibaTourmalineFacet
                
                info = ""
            case .ParaibaTourmalineFacet:
                towerBaseType = .Aquamarine
                
                rangeModifier = 900 / BASE_RANGE
                cooldownModifier = 0.6 / BASE_COOLDOWN
                projectileModifier = 1750 / BASE_PROJECTILE_SPEED
                damageBase = 125
                sidesPerDie = 79
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = ""
            case .UberStone:
                towerBaseType = .Amethyst
                
                rangeModifier = 1500 / BASE_RANGE
                cooldownModifier = 0.75 / BASE_COOLDOWN
                projectileModifier = 1000 / BASE_PROJECTILE_SPEED
                damageBase = 500
                sidesPerDie = 2000
                
                upgradeCost = 0
                upgradesTo = .Rock
                
                info = "Only the very luck have the chance ever to this stone of pure damage"
                
        }
    }
}




