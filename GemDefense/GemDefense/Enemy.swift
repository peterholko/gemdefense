//
//  Enemy.swift
//  GemDefense
//
//  Created by Peter Holko on 2016-05-21.
//  Copyright © 2016 Peter Holko. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

enum ArmorType : String {
    case Red, Blazed, White, Green, Yellow, Blue, Pink
}

class Enemy : SKSpriteNode {
    var game : GameScene!
    var greenHpBar : SKShapeNode!
    var redHpBar : SKShapeNode!
    var spriteName = ""
    var id = -1
    
    let maxWidth = 20
    let baseSpeed = 265.0

    var flying = false
    var attacking = true
    var speedModifier = 0.0
    var walkingSpeed = 0.5
    
    var enemyType : String = "axedwarf"
    
    var poisonDamage = 0.0
    var poisonDuration = 0.0
    var poisonModifier = 0.0
    var numPoison = 0
    
    var iceDuration = 0.0
    var iceModifier = 0.0
    var numIce = 0
    
    var stunDuration = 0.0
    var stunModifier = 0.0
    var numStun = 0
    
    var maxHp = 10
    var currHp = 0
    var armor = 0 
    var armorType : ArmorType = .Red
    
    var armorPenaltyValue : Double = 0.0
    var armorPenaltyDuration = 0.0
    var numArmorPenalty = 0
    
    var auraArmorPenaltyValue = 0.0
    var auraSpeedPenaltyValue = 0.0
    
    var path: [Point] = [Point]()
    var pathIndex: Int = 1
    var currentDest: CGPoint = CGPoint(x: 0, y: 0)
    

    init() {
        let texture = SKTexture(imageNamed: enemyType)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.setEnemyStats()
        
        self.currHp = self.maxHp
        self.initHpBar()
        
        if(flying) {
            enemyType = "batman"
        } else {
            enemyType = "axedwarf"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initHpBar() {
        greenHpBar = SKShapeNode(rectOf: CGSize(width: maxWidth, height: 4))
        greenHpBar.fillColor = .green
        greenHpBar.zPosition = 2
        greenHpBar.position = CGPoint(x: maxWidth / 2 - 2, y: 25)
        
        self.addChild(greenHpBar)
        
        redHpBar = SKShapeNode(rectOf: CGSize(width: maxWidth, height: 4))
        redHpBar.fillColor = .red
        redHpBar.zPosition = 1
        redHpBar.position = CGPoint(x: maxWidth / 2 - 2, y: 25)
        
        self.addChild(redHpBar)
    }
    
    func isDead() -> Bool {
        if currHp > 0 {
            return false
        } else {
            return true
        }
    }
    
    func applyIceSlow(modifier: Double) {
        if iceModifier == 0 {
            
            iceModifier = modifier
            iceDuration = 5.0
            numIce = 0
            
            let wait = SKAction.wait(forDuration: 1.0)
            let run = SKAction.run {
                self.removeIce()
            }
            
            self.run(SKAction.repeatForever(SKAction.sequence([wait, run])), withKey: "ice")
            
            if poisonModifier > 0 {
                texture = SKTexture(imageNamed: enemyType + "_icepoison")
            } else {
                texture = SKTexture(imageNamed: enemyType + "_ice")
            }
        } else {
        
            iceModifier = modifier
            iceDuration = 5.0
            numIce = 0
        }
    }
    
    func applyPoison(modifier: Double, damage: Double, duration : Double) {
        if poisonModifier == 0 {
            
            poisonDamage = damage
            poisonModifier = modifier
            poisonDuration = duration
            numPoison = 0
            
            let wait = SKAction.wait(forDuration: 1.0)
            let run = SKAction.run {
                self.applyPoisonDamage()
                self.removePoison()
            }
            
            self.run(SKAction.repeatForever(SKAction.sequence([wait, run])), withKey: "poison")
            
            if iceModifier > 0 {
                texture = SKTexture(imageNamed: enemyType + "_icepoison")
            } else {
                texture = SKTexture(imageNamed: enemyType + "_poison")
            }
        } else {
            poisonDamage = damage
            poisonModifier = modifier
            poisonDuration = duration
            numPoison = 0
        }
    }
    
    func applyStun(duration: Double) {
        if stunModifier == 0 {
            stunModifier = 1
            stunDuration = duration
            numStun = 0
            
            let wait = SKAction.wait(forDuration: 1.0)
            let run = SKAction.run {
                self.removeStun()
            }
            
            self.run(SKAction.repeatForever(SKAction.sequence([wait, run])), withKey: "stun")
        } else {
            stunModifier = 1
            stunDuration = duration
            numStun = 0
        }
    }
    
    func applyArmorPenalty(penalty: Double, duration: Double) {
        if armorPenaltyValue == 0.0 {
            armorPenaltyValue = penalty
            numArmorPenalty = 0
            
            let wait = SKAction.wait(forDuration: 1.0)
            let run = SKAction.run {
                self.removeArmorPenalty()
            }
            
            self.run(SKAction.repeatForever(SKAction.sequence([wait, run])), withKey: "armor")
        } else {
            armorPenaltyValue = penalty
            armorPenaltyDuration = duration
            numArmorPenalty = 0
        }
    }
    
    func applyAuraSpeedPenalty(penalty: Double) {
        auraSpeedPenaltyValue = penalty
    }
    
    func applyAuraArmorPenalty(penalty: Double) {
        auraArmorPenaltyValue = penalty
    }
    
    func removeIce() {
        numIce += 1
        
        if(Double(numIce) > iceDuration) {
            
            self.removeAction(forKey: "ice")
            iceModifier = 0
            
            texture = SKTexture(imageNamed: enemyType)
        }
    }
    
    func removePoison() {
        numPoison += 1
        
        if(Double(numPoison) > poisonDuration) {
            
            self.removeAction(forKey: "poison")
            poisonModifier = 0
            
            texture = SKTexture(imageNamed: enemyType)
        }
    }
    
    func removeStun() {
        numStun += 1
        
        if(Double(numStun) > stunDuration) {
            self.removeAction(forKey: "stun")
            
            stunModifier = 0
        }
    }
    
    func removeArmorPenalty() {
        numArmorPenalty += 1
        
        if(Double(numArmorPenalty) > armorPenaltyDuration) {
            
            self.removeAction(forKey: "armor")
            armorPenaltyValue = 0.0
        }
    }
    
    func removeAuraSpeedPenalty() {
        auraSpeedPenaltyValue = 0.0
    }
    
    func removeAuraArmorPenalty() {
        auraArmorPenaltyValue = 0.0
    }
    
    func applyPoisonDamage() {
        setDamage(damage: Int(poisonDamage))
        setHpBar()
    }
    
    func setHpBar() {
        let hpRatio = CGFloat(currHp) / CGFloat(maxHp)
        let hpWidth = hpRatio * CGFloat(maxWidth)
        
        greenHpBar.xScale = hpRatio
        greenHpBar.position = CGPoint(x: hpWidth / 2 - 2, y: 25)
    }
    
    func setDamage(damage: Int) {
        currHp -= damage
        
        if currHp <= 0 {
            game.removeEnemy(enemyId: id, killed: true)
        }
    }
    
    func setSprite() {
        spriteName = enemyType
        texture = SKTexture(imageNamed: spriteName)
    }
    
    func setGame(gameScene: GameScene) {
        game = gameScene
    }
    
    func setPath(_ fullPath: [Point]) {
        path = fullPath
        currentDest = CGPoint(x: path[0].x * TILE_SIZE, y: path[0].y * TILE_SIZE)
    }
    
    func setPosition() {
        let diff = currentDest - self.position
        let normalized = diff.normalized()
        
        let newPosition = self.position + normalized * CGFloat(calculateWalkingSpeed()) * CGFloat(speedModifier)
        self.position = newPosition
    }
    
    func calculateWalkingSpeed() -> Double {
        
        if(stunModifier > 0) {
            return walkingSpeed * (1 - stunModifier)
        }
        
        if(auraSpeedPenaltyValue > 0) {
            //Calculate first as it is allowed to stack with ice and poison
            walkingSpeed = walkingSpeed * auraSpeedPenaltyValue
        }
        
        if(iceModifier > 0 && poisonModifier > 0)
        {
            return walkingSpeed * (1 - iceModifier) * (1 - poisonModifier);
        }
        
        if(iceModifier > 0)
        {
            return walkingSpeed * (1 - iceModifier);
        }
        
        if(poisonModifier > 0)
        {
            return walkingSpeed * (1 - poisonModifier);
        }
        else
        {
            return walkingSpeed;
        }
    }

    func setEnemyStats() {
        switch(gameLevel) {
            case 0:
                maxHp = 10
                armor = 0
                armorType = .Yellow
                speedModifier = 265 / baseSpeed
            case 1:
                maxHp = 10
                armor = 0
                armorType = .Yellow
                speedModifier = 265 / baseSpeed
            case 2:
                maxHp = 30
                armor = 0
                armorType = .Blazed
                speedModifier = 265 / baseSpeed
            case 3:
                maxHp = 55
                armor = 0
                armorType = .White
                speedModifier = 265 / baseSpeed
            case 4:
                maxHp = 70
                armor = 0
                armorType = .Pink
                speedModifier = 230 / baseSpeed
                flying = true
            case 5:
                maxHp = 90
                armor = 0
                armorType = .Green
                speedModifier = 275 / baseSpeed
            case 6:
                maxHp = 120
                armor = 0
                armorType = .Green
                speedModifier = 275 / baseSpeed
            case 7:
                maxHp = 178
                armor = 0
                armorType = .Pink
                speedModifier = 285 / baseSpeed
            case 8:
                maxHp = 240
                armor = 0
                armorType = .Pink
                speedModifier = 230 / baseSpeed
                flying = true
            case 9:
                maxHp = 300
                armor = 0
                armorType = .White
                speedModifier = 285 / baseSpeed
            case 10:
                maxHp = 470
                armor = 1
                armorType = .Blue
                speedModifier = 285 / baseSpeed
            case 11:
                maxHp = 490
                armor = 1
                armorType = .Green
                speedModifier = 285 / baseSpeed
            case 12:
                maxHp = 450
                armor = 1
                armorType = .Pink
                speedModifier = 250 / baseSpeed
                flying = true
            case 13:
                maxHp = 570
                armor = 1
                armorType = .Yellow
                speedModifier = 295 / baseSpeed
            case 14:
                maxHp = 650
                armor = 1
                armorType = .Blazed
                speedModifier = 295 / baseSpeed
            case 15:
                maxHp = 1000
                armor = 0
                armorType = .Red
                speedModifier = 295 / baseSpeed
            case 16:
                maxHp = 725
                armor = 1
                armorType = .Pink
                speedModifier = 250 / baseSpeed
                flying = true
            case 17:
                maxHp = 1350
                armor = 1
                armorType = .Red
                speedModifier = 295 / baseSpeed
            case 18:
                maxHp = 1550
                armor = 1
                armorType = .Pink
                speedModifier = 300 / baseSpeed
            case 19:
                maxHp = 1950
                armor = 1
                armorType = .Blue
                speedModifier = 300 / baseSpeed
            case 20:
                maxHp = 1350
                armor = 1
                armorType = .Pink
                speedModifier = 280 / baseSpeed
                flying = true
            case 21:
                maxHp = 2300
                armor = 2
                armorType = .White
                speedModifier = 315 / baseSpeed
            case 22:
                maxHp = 2530
                armor = 2
                armorType = .Green
                speedModifier = 315 / baseSpeed
            case 23:
                maxHp = 3000
                armor = 2
                armorType = .Red
                speedModifier = 300 / baseSpeed
            case 24:
                maxHp = 2500
                armor = 1
                armorType = .Pink
                speedModifier = 280 / baseSpeed
                flying = true
            case 25:
                maxHp = 3750
                armor = 2
                armorType = .Red
                speedModifier = 335 / baseSpeed
            case 26:
                maxHp = 4500
                armor = 2
                armorType = .Red
                speedModifier = 340 / baseSpeed
            case 27:
                maxHp = 5000
                armor = 2
                armorType = .Blue
                speedModifier = 340 / baseSpeed
            case 28:
                maxHp = 4150
                armor = 2
                armorType = .Pink
                speedModifier = 275 / baseSpeed
                flying = true
            case 29:
                maxHp = 6750
                armor = 2
                armorType = .White
                speedModifier = 345 / baseSpeed
            case 30:
                maxHp = 7150
                armor = 3
                armorType = .Green
                speedModifier = 350 / baseSpeed
            case 31:
                maxHp = 8000
                armor = 3
                armorType = .Blazed
                speedModifier = 350 / baseSpeed
            case 32:
                maxHp = 6250
                armor = 2
                armorType = .Pink
                speedModifier = 320 / baseSpeed
                flying = true
            case 33:
                maxHp = 9550
                armor = 3
                armorType = .Red
                speedModifier = 355 / baseSpeed
            case 34:
                maxHp = 10200
                armor = 3
                armorType = .Yellow
                speedModifier = 355 / baseSpeed
            case 35:
                maxHp = 11500
                armor = 3
                armorType = .Blue
                speedModifier = 355 / baseSpeed
            case 36:
                maxHp = 8500
                armor = 2
                armorType = .Pink
                speedModifier = 320 / baseSpeed
                flying = true
            case 37:
                maxHp = 13000
                armor = 3
                armorType = .Yellow
                speedModifier = 360 / baseSpeed
            case 38:
                maxHp = 15000
                armor = 3
                armorType = .Red
                speedModifier = 365 / baseSpeed
            case 39:
                maxHp = 17000
                armor = 3
                armorType = .White
                speedModifier = 375 / baseSpeed
            case 40:
                maxHp = 10500
                armor = 2
                armorType = .Pink
                speedModifier = 350 / baseSpeed
                flying = true
            case 41:
                maxHp = 19500
                armor = 7
                armorType = .Green
                speedModifier = 380 / baseSpeed
            case 42:
                maxHp = 23000
                armor = 18
                armorType = .Blue
                speedModifier = 390 / baseSpeed
            case 43:
                maxHp = 26000
                armor = 15
                armorType = .Yellow
                speedModifier = 400 / baseSpeed
            case 44:
                maxHp = 13000
                armor = 5
                armorType = .Pink
                speedModifier = 370 / baseSpeed
                flying = true
            case 45:
                maxHp = 28500
                armor = 15
                armorType = .Red
                speedModifier = 400 / baseSpeed
            case 46:
                maxHp = 30000
                armor = 15
                armorType = .Blazed
                speedModifier = 400 / baseSpeed
            case 47:
                maxHp = 33000
                armor = 15
                armorType = .White
                speedModifier = 400 / baseSpeed
            case 48:
                maxHp = 15000
                armor = 5
                armorType = .Pink
                speedModifier = 380 / baseSpeed
                flying = true
            case 49:
                maxHp = 35000
                armor = 15
                armorType = .Green
                speedModifier = 400 / baseSpeed
            case 50:
                maxHp = 200000
                armor = 15
                armorType = .Green
                speedModifier = 400 / baseSpeed
                flying = true
            default:
                maxHp = 5000

        }
    }
    
    func setSurvivalLevels() {
        switch(gameLevel) {
        case 11:
            maxHp = 650
            armor = 1
            armorType = .Green
            speedModifier = 285 / baseSpeed
        case 12:
            maxHp = 550
            armor = 1
            armorType = .Pink
            speedModifier = 250 / baseSpeed
            flying = true
        case 13:
            maxHp = 800
            armor = 1
            armorType = .Yellow
            speedModifier = 295 / baseSpeed
        case 14:
            maxHp = 925
            armor = 1
            armorType = .Blazed
            speedModifier = 295 / baseSpeed
        case 15:
            maxHp = 1350
            armor = 1
            armorType = .Red
            speedModifier = 295 / baseSpeed
        case 16:
            maxHp = 850
            armor = 1
            armorType = .Pink
            speedModifier = 295 / baseSpeed
            flying = true
        case 17:
            maxHp = 1750
            armor = 1
            armorType = .Red
            speedModifier = 325 / baseSpeed
        case 18:
            maxHp = 2000
            armor = 1
            armorType = .Pink
            speedModifier = 325 / baseSpeed
        case 19:
            maxHp = 2500
            armor = 1
            armorType = .Blue
            speedModifier = 350 / baseSpeed
        case 20:
            maxHp = 1550
            armor = 1
            armorType = .Pink
            speedModifier = 280 / baseSpeed
            flying = true
        case 21:
            maxHp = 3250
            armor = 2
            armorType = .White
            speedModifier = 400 / baseSpeed
        default:
            maxHp = 100000
        }
    
        if gameLevel > 21 {
            let levelInc = Int(gameLevel) - 21
            var maxHp = 7500 * (1 + Double(levelInc) * 0.1)
            
            if gameLevel % 4 == 0 {
                maxHp = maxHp  * 0.3333
                armorType = .Pink
                armor = Int(gameLevel / 5)
            } else {
                armorType = randomArmorType(randNum: Int(random(min: 0, max: 6)))
                armor = Int(gameLevel / 4)
            }
            
            speedModifier = 550 / baseSpeed
        }
    }
    
    func randomArmorType(randNum : Int) -> ArmorType {
        var armorType : ArmorType = .Pink
        //Red, Blazed, White, Green, Yellow, Blue, Pink
        
        switch(randNum) {
        case 0:
            armorType = .Red
        case 1:
            armorType = .Blazed
        case 2:
            armorType = .White
        case 3:
            armorType = .Green
        case 4:
            armorType = .Yellow
        case 5:
            armorType = .Blue
        case 6:
            armorType = .Pink
        default:
            armorType = .Pink
        }
        
        return armorType
    }
}
