//
//  GameScene.swift
//  GemDefense
//
//  Created by Peter Holko on 2016-05-21.
//  Copyright (c) 2016 Peter Holko. All rights reserved.
//

import SpriteKit
import DeviceCheck

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
}

enum Phase : String {
    case SelectDiff, Place, Move, Select, Wave
}

enum Diff : String {
    case NotSelected, Easy, Hard, Survival
}

struct SpecialTower {
    var req : [(quality: TowerQuality, type: TowerBaseType)]
    var towerType : TowerType
    
    init() {
        req = [(quality: TowerQuality, type: TowerBaseType)]()
        towerType = TowerType.Rock
    }
}

var gameLevel : Int = 0
var qualityLevel : Int = 0

class GameScene: SKScene {
    let bg = SKSpriteNode(imageNamed: "bg")
    
    let westArrow = SKSpriteNode(imageNamed: "westarrow")
    let eastArrow = SKSpriteNode(imageNamed: "eastarrow")
    let northArrow = SKSpriteNode(imageNamed: "northarrow")
    let southArrow = SKSpriteNode(imageNamed: "southarrow")

    let ui = UI()
    
    var map = Map()
    
    var placedTower:Tower = Tower()
    
    var selectedTower:Tower!
    var lastSelectedTower:Tower!
    var lastKeepCombineTower:Tower!

    var phase : Phase = .SelectDiff
    
    var allTowers = [Tower]()
    
    var towers = [Tower]()
    var enemies = [Enemy]()
    
    var roundTowers = [Tower]()
    var indexTowers : Int = 0
    var enemyIndex : Int = 0
    
    var filledTowers = [Tower]()
    
    var specialTowers = [SpecialTower]()
    var specialFoundTower:SpecialTower!
    
    var diffLevel : Diff = .NotSelected
    var lives : Int = 10
    var gold : Int = 10
    var time : Int = 0
    var score : Int = 0
    
    var lifeCost : Int = 10
    
    var timer : Timer?
    var isTimerRunning = false
    
    var armorTable : Armor = Armor()
    var damageTable : Damage = Damage()
    
    var creatingEnemies : Bool = false
    var flyingLevel : Bool = false
    var armorLevel : Int = 0

    
    var lost : Bool = false
    
    var chippedChance : Int = 0
    var flawedChance : Int = 0
    var normalChance : Int = 0
    var flawlessChance : Int = 0
    var perfectChance : Int = 0
    
    var infoLabel : UILabel!
    var upgradeLabel : UILabel!
    
    var nameField : UITextField!
    
    var rangeCircle : SKShapeNode!
    
    var nearPlacedTower : Bool = false
    var placedTowerOrigPos : CGPoint!

    override init(size: CGSize) {
        super.init(size: size)
        
        initUI()
        initBackground()
        initRestricted()
        initSpecialTowers()
        initRangeCircle()
        
        setUpgradeChanceCost()
    }
    
    func initUI() {
        ui.setPanel()
        ui.setTopMenu()

        ui.initPlaceButton(placeFunc: placeAction)
        ui.initKeepButton(keepFunc: keepAction)
        ui.initCombineButton(combineFunc: combineAction)
        ui.initCombineSpecialButton(combineSpecialFunc: combineSpecialAction)
        ui.initUpgradeTowerButton(upgradeTowerFunc: upgradeTowerAction)
        ui.initRemoveButton(removeFunc: removeAction)
        ui.initTopMenuText()
        ui.initInfoPopups()
        ui.initLostPopup()
        ui.initSubmitScoreButton(submitScoreFunc: submitScoreAction)
        
        ui.initResetPopup()
        ui.initResetYesButton(resetYesFunc: resetYesAction)
        ui.initResetNoButton(resetNoFunc: resetNoAction)
        ui.initResetButton(resetFunc: resetConfirmAction)
        
        ui.initUpgradeButton(upgradeFunc: upgradeAction)
        ui.initUpgradePopup()
        ui.initUpgradeYesButton(upgradeYesFunc: upgradeYesAction)
        ui.initUpgradeNoButton(upgradeNoFunc: upgradeNoAction)
        
        ui.initBuyLivesButton(buyLivesFunc: buyLivesConfirmAction)
        ui.initBuyLivesPopup()
        ui.initBuyLivesYesButton(buyLivesYesFunc: buyLivesYesAction)
        ui.initBuyLivesNoButton(buyLivesNoFunc: buyLivesNoAction)
        
        ui.initEasyButton(easyFunc: easyAction)
        ui.initHardButton(hardFunc: hardAction)
        ui.initSurvivalButton(survivalFunc: survivalAction)
        
        ui.resetButton.isHidden = false
        ui.buyLivesButton.isHidden = false
        
        ui.easyButton.isHidden = false
        ui.hardButton.isHidden = false
        ui.survivalButton.isHidden = false
        
        ui.setDiffLabel(text: diffLevel.rawValue)
        ui.setLevelLabel(text: String(gameLevel))
        ui.setLivesLabel(text: String(lives))
        ui.setGoldLabel(text: String(gold))
        ui.setTimeLabel(text: String(time))
        ui.setScoreLabel(text: String(score))
        
        addChild(ui)
    }
    
    func resetGame() {

        
        gameLevel = 0
        qualityLevel = 0
        
        diffLevel = .NotSelected
        lives = 10
        gold = 10
        time = 0
        score = 0
        
        allTowers.removeAll()
        towers.removeAll()
        enemies.removeAll()
        roundTowers.removeAll()
        filledTowers.removeAll()
        
        indexTowers = 0
        enemyIndex = 0
        
        creatingEnemies = false
        flyingLevel = false
        armorLevel = 0
        
        lost = false
        
        selectedTower = nil
        lastSelectedTower = nil
        lastKeepCombineTower = nil
        
        phase = .SelectDiff
        
        setUpgradeChanceCost()
        
        bg.removeAllChildren()
        
        map = Map()
        initRestricted()
        
        ui.easyButton.isHidden = false
        ui.hardButton.isHidden = false
        ui.survivalButton.isHidden = false
        
        ui.setDiffLabel(text: diffLevel.rawValue)
        ui.setLevelLabel(text: String(gameLevel))
        ui.setLivesLabel(text: String(lives))
        ui.setGoldLabel(text: String(gold))
        ui.setTimeLabel(text: String(time))
        ui.setScoreLabel(text: String(score))
    }
    
    func initBackground() {
        backgroundColor = SKColor.black
        
        bg.anchorPoint = CGPoint(x: 0, y: 0)
        bg.position = CGPoint(x: 0, y: -168)
        bg.zPosition = -1.0
        addChild(bg)
    }
    
    func setupLabel() {
        
        let frame1 = CGRect(
            x: 500,
            y: 57,
            width: 160,
            height: 300)
        
        infoLabel = UILabel(frame: frame1)
        infoLabel.text = ""
        infoLabel.textColor = .black
        infoLabel.textAlignment = .left
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont(name: "Marker Felt", size: 12)
        
        self.view?.addSubview(infoLabel)
        
        let frame2 = CGRect(
            x: 175,
            y: 115,
            width: 160,
            height: 300)
        
        upgradeLabel = UILabel(frame: frame2)
        upgradeLabel.text = ""
        upgradeLabel.textColor = .black
        upgradeLabel.textAlignment = .left
        upgradeLabel.numberOfLines = 0
        upgradeLabel.font = UIFont(name: "Marker Felt", size: 12)
        
        self.view?.addSubview(upgradeLabel)
        
        let frame3 = CGRect(
            x: 250,
            y: 85,
            width: 160,
            height: 25)
        
        nameField = UITextField(frame: frame3)
        nameField.text = "Enter Your Name"
        nameField.textColor = .black
        nameField.textAlignment = .left
        nameField.borderStyle = .roundedRect
        nameField.font = UIFont(name: "Marker Felt", size: 12)
        nameField.isHidden = true
        
        self.view?.addSubview(nameField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.view!.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        if phase != .SelectDiff {
            if recognizer.state == .began {
                //Pan Began
                var touchLocation = recognizer.location(in: recognizer.view)
                touchLocation = self.convertPoint(fromView: touchLocation)
                print("pan location: " + String(describing: touchLocation))
                
                if(phase == .Move) {
                    let panLocation = CGPoint(x: touchLocation.x, y: touchLocation.y + 168)
                    if(checkCollision(placedTower.position, radius1: 50, center2: panLocation, radius2: 1)) {
                        nearPlacedTower = true
                        placedTowerOrigPos = placedTower.position
                    } else {
                        nearPlacedTower = false
                    }
                }
                
            } else if recognizer.state == .changed {
                //Pan chnaged
                var translation = recognizer.translation(in: recognizer.view!)
                translation = CGPoint(x: translation.x, y: -translation.y)
                
                if(!nearPlacedTower) {
                    self.panForTranslation(translation)
                    recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
                } else if(phase == .Move) {
                    let tileX:Int = Int(floor(placedTowerOrigPos.x + translation.x) / CGFloat(TILE_SIZE))
                    let tileY:Int = Int(floor(placedTowerOrigPos.y + translation.y) / CGFloat(TILE_SIZE))
                    
                    let tileStatus = checkTowerLocation(tileX, tileY: tileY)
                    
                    if(tileStatus == Tile.empty) {
                        placedTower.position = CGPoint(x: (tileX - 1) * TILE_SIZE, y: (tileY - 1) * TILE_SIZE)
                        placedTower.tileX = tileX
                        placedTower.tileY = tileY
                    }
                }
                
            } else if recognizer.state == .ended {
                //Pan ended
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.endEditing(true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if phase != .SelectDiff {
            print("touchesEnded - phase: " + String(describing: phase))
            print("Touches Count" + String(touches.count))
            for t in touches {
            
                let loc : CGPoint = t.location(in: self)
                let nodes = self.nodes(at: loc)
                
                print(loc)
                
                if(phase == .Place) {
                    processPlacePhase(loc)
                } else if(phase == .Move) {
                    processMovePhase(loc, touchedNode: placedTower)
                }
                
                print("Node count: " + String(nodes.count))
                
                for n in nodes {
                    print("Node" + String(describing: n))
                    if let towerNode = n as? Tower {
                        print("TowerNode: " + String(describing: towerNode))
                        if(phase == .Place || phase == .Move) {
                            
                            setSelectedTower(tower: towerNode)
                            ui.hideButtons()
                            ui.placeButton.isHidden = false
                            ui.upgradeButton.isHidden = false
                        }
                        if(phase == .Select) {
                            processSelectPhase(loc, touchedNode: towerNode)
                        } else if(phase == .Wave) {
                            processWavePhase(loc, touchedNode: towerNode)
                        }
                    }
                }
            }
        }
    }

    func processPlacePhase(_ touchLocation: CGPoint) {
        let localX = touchLocation.x - bg.position.x
        let localY = touchLocation.y - bg.position.y

        let tileX:Int = Int(floor(localX) / CGFloat(TILE_SIZE))
        let tileY:Int = Int(floor(localY) / CGFloat(TILE_SIZE))

        let tileStatus = checkTowerLocation(tileX, tileY: tileY)
        print("tileStatus: " + String(describing: tileStatus))
        if(tileStatus == Tile.empty) {
            print("Place Tower")
            placedTower = Tower()
            placedTower.game = self
            
            placedTower.towerPlacedThisRound = true
            placedTower.name = String(indexTowers)
            placedTower.anchorPoint = CGPoint(x: 0, y: 0)
            placedTower.isUserInteractionEnabled = false
            placedTower.zPosition = 1
            
            placedTower.position = CGPoint(x: (tileX - 1) * TILE_SIZE, y: (tileY - 1) * TILE_SIZE)
            placedTower.tileX = tileX
            placedTower.tileY = tileY
            placedTower.id = indexTowers
            placedTower.setSelectSprite()
            
            allTowers.append(placedTower)

            bg.addChild(placedTower)
            
            indexTowers += 1
            
            setSelectedTower(tower: placedTower)
            
            ui.hideButtons()
            ui.placeButton.isHidden = false
            ui.upgradeButton.isHidden = false
            
            phase = .Move
        } else if(tileStatus == Tile.restricted) {
            ui.showCannotBuildThere()
        } else if(tileStatus == Tile.blocked) {
            ui.showBlocking()
        }
    }
    
    func processMovePhase(_ touchLocation: CGPoint, touchedNode: SKNode) {
        let localX = touchLocation.x - bg.position.x
        let localY = touchLocation.y - bg.position.y
    
        let tileX:Int = Int(floor(localX) / CGFloat(TILE_SIZE))
        let tileY:Int = Int(floor(localY) / CGFloat(TILE_SIZE))
    
        let tileStatus = checkTowerLocation(tileX, tileY: tileY)
        print("Tile Status: " + String(describing: tileStatus))
        
        if(tileStatus == Tile.empty) {
            print("Tile empty")
            
            placedTower.position = CGPoint(x: (tileX - 1) * TILE_SIZE, y: (tileY - 1) * TILE_SIZE)
            placedTower.tileX = tileX
            placedTower.tileY = tileY
            
            setSelectedTower(tower: placedTower)
            
            ui.hideButtons()
            ui.placeButton.isHidden = false
            ui.upgradeButton.isHidden = false
        } else if(tileStatus == Tile.restricted) {
            ui.showCannotBuildThere()
        } else if(tileStatus == Tile.blocked) {
            ui.showBlocking()
        }
    }
    
    func processSelectPhase(_ touchLocation: CGPoint, touchedNode: SKNode) {
        print("Select Phase")

        if let touchedTower = touchedNode as? Tower {
            setSelectedTower(tower: touchedTower)
        }
    }
    
    func processWavePhase(_ touchLocation: CGPoint, touchedNode: SKNode) {
        print("Wave Phase")
        
        if let touchedTower = touchedNode as? Tower {
            setSelectedTower(tower: touchedTower)
        }
    }
        
    func placeAction() {
        print("Place action! Phase: " + String(describing: phase))
        if(phase == .Move) {
            processPlace()
        }
    }
    
    func keepAction() {
        print("Keep Action!")
        if(phase == .Select) {
            processKeep()
        }
    }
    
    func combineAction() {
        print("Combine Action!")
    
        processCombine()
    }
    
    func combineSpecialAction() {
        print("Combine Special Action")
        
        processCombineSpecial()
    }
    
    func upgradeTowerAction() {
        print("Upgrade Tower Action")
        
        processUpgradeTower()
    }
    
    func removeAction() {
        print("Remove Tower Action")
        if (selectedTower != nil) {
            if(selectedTower.towerType == TowerType.Rock) {
                self.removeTower()
            }
        }
    }
    
    func upgradeAction() {
        print("Upgrade Action")
        
        ui.upgradeTextAreaSprite.isHidden = false
        upgradeLabel.isHidden = false
        
        upgradeLabel.text = getUpgradeText()
        upgradeLabel.frame =  CGRect(
            x: 175,
            y: 115,
            width: 160,
            height: 150)
        upgradeLabel.sizeToFit()
    }
    
    func upgradeYesAction() {
        print("Upgrade Yes Action")
    
        if gold >= getUpgradeCost() {
            gold -= getUpgradeCost()
            qualityLevel += 1
            
            setUpgradeChanceCost()
            
            ui.setGoldLabel(text: String(gold))
            ui.upgradeTextAreaSprite.isHidden = true
            upgradeLabel.isHidden = true
        }
    }
    
    func upgradeNoAction() {
        print("Upgrade No Action")
        
        ui.upgradeTextAreaSprite.isHidden = true
        upgradeLabel.isHidden = true
    }
    
    func resetConfirmAction() {
        print("Reset Confirm Action")
        
        ui.resetGameSprite.isHidden = false
    }
    
    func resetYesAction() {
        print("Reset Yes Action")
        
        resetGame()
        ui.resetGameSprite.isHidden = true
    }
    
    func resetNoAction() {
        print("Reset No Action")
        
        ui.resetGameSprite.isHidden = true
    }
    
    func buyLivesConfirmAction() {
        print("Buy Lives Action")
        
        ui.buyLivesTextAreaSprite.isHidden = false
        upgradeLabel.isHidden = false
        
        upgradeLabel.text = "Buy 1 life for \(lifeCost) gold each."
        upgradeLabel.frame =  CGRect(
            x: 175,
            y: 115,
            width: 160,
            height: 150)
        upgradeLabel.sizeToFit()
    }
    
    func buyLivesYesAction() {
        print("Buy Lives Yes Action")
        
        if gold >= 10 {
            gold -= lifeCost
            lives += 1
            lifeCost += 1
            
            ui.setGoldLabel(text: String(gold))
            ui.setLivesLabel(text: String(lives))
            ui.buyLivesTextAreaSprite.isHidden = true
            upgradeLabel.isHidden = true
        }
    }
    
    func buyLivesNoAction() {
        print("Buy Lives No Action")
        
        ui.buyLivesTextAreaSprite.isHidden = true
        upgradeLabel.isHidden = true
    }
    
    func easyAction() {
        diffLevel = .Easy
        phase = .Place
        armorLevel = 0
        
        ui.setDiffLabel(text: diffLevel.rawValue)
        ui.hideDiffButtons()
    }
    
    func hardAction() {
        diffLevel = .Hard
        phase = .Place
        armorLevel = 8
        
        ui.setDiffLabel(text: diffLevel.rawValue)
        ui.hideDiffButtons()
    }
    
    func survivalAction() {
        diffLevel = .Survival
        phase = .Place
        armorLevel = 13
        
        ui.setDiffLabel(text: diffLevel.rawValue)
        ui.hideDiffButtons()
    }
    
    func submitScoreAction() {
        print("Upload score")
        print("Name: " + (nameField.text)!)
        
        uploadScore(name: nameField.text!)
    }
    
    func processPlace() {
        print("Process Place")
        let tileX = placedTower.tileX
        let tileY = placedTower.tileY
     
        map.setBlocked(tileX, y: tileY)
        map.setBlocked(tileX, y: tileY - 1)
        map.setBlocked(tileX - 1, y: tileY)
        map.setBlocked(tileX - 1, y: tileY - 1)
        
        let path : [Point] = findPath(flying: false)
        
        if path.isEmpty {
            print("Invalid path")
            
            ui.showBlocking()
            
            // Reopen tiles
            map.setEmpty(tileX, y: tileY)
            map.setEmpty(tileX, y: tileY - 1)
            map.setEmpty(tileX - 1, y: tileY)
            map.setEmpty(tileX - 1, y: tileY - 1)
        } else {
            print("Placing tower...")
            
            placedTower.randomTower()
            roundTowers.append(placedTower)
            
            if roundTowers.count == 5 {
                phase = .Select
                
            } else {
                phase = .Place
            }
            
            setSelectedTower(tower: placedTower)
        }
    }
    
    func processKeep() {
        // Do not change towers to rocks if no tower is selected
        
        for roundTower in roundTowers {
            if !roundTower.selected {
                roundTower.changeTower(TowerType.Rock, quality: TowerQuality.Chipped)
               
            } else {
                towers.append(roundTower)
            }
        }

        processWave()
    }
    
    func processCombine() {
        
        for roundTower in roundTowers {
            if !roundTower.selected {
                roundTower.changeTower(TowerType.Rock, quality: TowerQuality.Chipped)
                
            } else {
                towers.append(roundTower)
            }
        }
        
        selectedTower.increaseQuality()
        selectedTower.changeTower(TowerType.Standard, quality: selectedTower.towerQuality)
        
        lastKeepCombineTower = selectedTower
        
        processWave()
    }
    
    func processCombineSpecial() {
        if phase == .Select {
            
            for roundTower in roundTowers {
                if !roundTower.selected {
                    roundTower.changeTower(TowerType.Rock, quality: TowerQuality.Chipped)
                } else {
                    towers.append(roundTower)
                }
            }
            
            selectedTower.changeTower(specialFoundTower.towerType, quality: TowerQuality.Chipped)

            lastKeepCombineTower = nil
            
            processWave()
        } else {
            for filledTower in filledTowers {
                if !filledTower.selected {
                    filledTower.changeTower(TowerType.Rock, quality: TowerQuality.Chipped)
                }
            }
            
            selectedTower.changeTower(specialFoundTower.towerType, quality: TowerQuality.Chipped)
            
            setSelectedTower(tower: selectedTower)
            
            lastKeepCombineTower = nil
        }
    }
    
    func processUpgradeTower() {
        if (selectedTower != nil) {
            if gold >= selectedTower.upgradeCost {
                gold -= selectedTower.upgradeCost
                ui.setGoldLabel(text: String(gold))
                
                selectedTower.changeTower(selectedTower.upgradesTo, quality: .Perfect)
                setSelectedTower(tower: selectedTower)
            }
        }
    }
    
    func processWave() {
        phase = .Wave
        
        //UI previous wave buttons
        ui.hideButtons()
        
        //Load wave of enemies
        loadWave()
        
        //Apply speed and damage auras
        checkAuras()
        
        //Set UI buttons for any newly selected tower
        setSelectedTower(tower: selectedTower)
        
        //Activate towers weapons
        activatedTowers(activate: true)
        
        //Start timer
        startTimer()
    }
    
    func setSelectedTower(tower: Tower) {
        if lastSelectedTower != nil {
            lastSelectedTower?.setSelect(selectStatus: false)
        }
        
        selectedTower = tower
        selectedTower.setSelect(selectStatus: true)
        
        if selectedTower.calculateRange() > 0 {
            drawRangeCircle(center: selectedTower.position, radius: CGFloat(selectedTower.calculateRange()))
        } else {
            rangeCircle.isHidden = true
        }
            
        lastSelectedTower = selectedTower
        
        setUIButtons()
        
        setInfoBoxText()
    }
    
    func setInfoBoxText() {
        infoLabel.text = selectedTower.getInfoBox()
        infoLabel.frame =  CGRect(
            x: 500,
            y: 57,
            width: 160,
            height: 150)
        infoLabel.sizeToFit()
    }
    
    func activatedTowers(activate: Bool) {
        for tower in towers {
            
            if activate {
                tower.attackEnemy()
            } else {
                tower.attackStop()
            }
        }
    }
    
    func removeTower() {
        let tileX = selectedTower.tileX
        let tileY = selectedTower.tileY
        
        let index = allTowers.index(where: {$0.id == selectedTower.id})
        allTowers.remove(at: index!)
        
        bg.removeChildren(in: [selectedTower])
        
        // Reopen tiles
        map.setEmpty(tileX, y: tileY)
        map.setEmpty(tileX, y: tileY - 1)
        map.setEmpty(tileX - 1, y: tileY)
        map.setEmpty(tileX - 1, y: tileY - 1)
    }
    
    func removeEnemy(enemyId: Int, killed: Bool) {
        let index = enemies.index(where: {$0.id == enemyId})
        
        if index != nil {
            print("Removing Enemy \(enemyId)")
            enemies[index!].removeFromParent()
            enemies.remove(at: index!)
            
            if killed {
                gold += (gameLevel / 4) + 1
                
                ui.setGoldLabel(text: String(gold))
                
                if enemies.count == 0 && creatingEnemies == false {
                    activatedTowers(activate: false)
                    
                    resetRound()
                }
            } else {
                let npcLifeCost:Int = 1 + Int(Double(gameLevel) / 4.0)
                lives -= npcLifeCost
                
                ui.setLivesLabel(text: String(lives))
                
                if(lives <= 0 && (!lost)) {
                    processLost()
                } else if(enemies.count == 0 && creatingEnemies == false) {
                    activatedTowers(activate: false)
                    resetRound()
                }
            }
        } else {
            print("Enemy \(enemyId) does not exist in Enemies")
        }
    }
    
    func processLost() {
        print("Lost!")
        ui.lostSprite.isHidden = false
        nameField.isHidden = false
        
        stopTimerTest()
    }
    
    func resetRound() {
        phase = .Place
        
        roundTowers.removeAll()
        
        gameLevel += 1
        gold = gold + (5 + (gameLevel * 2))
        
        stopTimerTest()
        updateScore()
        
        ui.setLevelLabel(text: String(gameLevel))
        ui.setScoreLabel(text: String(score))
        ui.setGoldLabel(text: String(gold))
    }
    
    func initSpecialTowers() {
        
        var blackOpal = SpecialTower()
        blackOpal.towerType = TowerType.BlackOpal
        blackOpal.req.append((quality: TowerQuality.Perfect, type: TowerBaseType.Opal))
        blackOpal.req.append((quality: TowerQuality.Flawless, type: TowerBaseType.Diamond))
        blackOpal.req.append((quality: TowerQuality.Normal, type: TowerBaseType.Aquamarine))
        
        specialTowers.append(blackOpal)
        
        var bloodStone = SpecialTower()
        bloodStone.towerType = TowerType.BloodStone
        bloodStone.req.append((quality: TowerQuality.Perfect, type: TowerBaseType.Ruby))
        bloodStone.req.append((quality: TowerQuality.Flawless, type: TowerBaseType.Aquamarine))
        bloodStone.req.append((quality: TowerQuality.Normal, type: TowerBaseType.Amethyst))
        
        specialTowers.append(bloodStone)
        
        var darkEmerald = SpecialTower()
        darkEmerald.towerType = TowerType.DarkEmerald
        darkEmerald.req.append((quality: TowerQuality.Perfect, type: TowerBaseType.Emerald))
        darkEmerald.req.append((quality: TowerQuality.Flawless, type: TowerBaseType.Sapphire))
        darkEmerald.req.append((quality: TowerQuality.Flawed, type: TowerBaseType.Topaz))
        
        specialTowers.append(darkEmerald)
        
        var gold = SpecialTower()
        gold.towerType = TowerType.Gold
        gold.req.append((quality: TowerQuality.Perfect, type: TowerBaseType.Amethyst))
        gold.req.append((quality: TowerQuality.Flawless, type: TowerBaseType.Amethyst))
        gold.req.append((quality: TowerQuality.Flawed, type: TowerBaseType.Diamond))
        
        specialTowers.append(gold)
        
        var jade = SpecialTower()
        jade.towerType = TowerType.Jade
        jade.req.append((quality: TowerQuality.Normal, type: TowerBaseType.Emerald))
        jade.req.append((quality: TowerQuality.Normal, type: TowerBaseType.Opal))
        jade.req.append((quality: TowerQuality.Flawed, type: TowerBaseType.Sapphire))
        
        specialTowers.append(jade)
        
        var malachite = SpecialTower()
        malachite.towerType = TowerType.Malachite
        malachite.req.append((quality: TowerQuality.Chipped, type: TowerBaseType.Emerald))
        malachite.req.append((quality: TowerQuality.Chipped, type: TowerBaseType.Opal))
        malachite.req.append((quality: TowerQuality.Chipped, type: TowerBaseType.Aquamarine))
        
        specialTowers.append(malachite)
        
        var paraiba = SpecialTower()
        paraiba.towerType = TowerType.Paraiba
        paraiba.req.append((quality: TowerQuality.Perfect, type: TowerBaseType.Aquamarine))
        paraiba.req.append((quality: TowerQuality.Flawless, type: TowerBaseType.Opal))
        paraiba.req.append((quality: TowerQuality.Flawed, type: TowerBaseType.Emerald))
        
        specialTowers.append(paraiba)
       
        var pinkDiamond = SpecialTower()
        pinkDiamond.towerType = TowerType.PinkDiamond
        pinkDiamond.req.append((quality: TowerQuality.Perfect, type: TowerBaseType.Diamond))
        pinkDiamond.req.append((quality: TowerQuality.Normal, type: TowerBaseType.Topaz))
        pinkDiamond.req.append((quality: TowerQuality.Normal, type: TowerBaseType.Diamond))
        
        specialTowers.append(pinkDiamond)
    
        var redCrystal = SpecialTower()
        redCrystal.towerType = TowerType.RedCrystal
        redCrystal.req.append((quality: TowerQuality.Flawless, type: TowerBaseType.Emerald))
        redCrystal.req.append((quality: TowerQuality.Normal, type: TowerBaseType.Ruby))
        redCrystal.req.append((quality: TowerQuality.Flawed, type: TowerBaseType.Amethyst))
        
        specialTowers.append(redCrystal)
        
        var silver = SpecialTower()
        silver.towerType = TowerType.Silver
        silver.req.append((quality: TowerQuality.Chipped, type: TowerBaseType.Diamond))
        silver.req.append((quality: TowerQuality.Chipped, type: TowerBaseType.Topaz))
        silver.req.append((quality: TowerQuality.Chipped, type: TowerBaseType.Sapphire))
        
        specialTowers.append(silver)
        
        var starRuby = SpecialTower()
        starRuby.towerType = TowerType.StarRuby
        starRuby.req.append((quality: TowerQuality.Flawed, type: TowerBaseType.Ruby))
        starRuby.req.append((quality: TowerQuality.Chipped, type: TowerBaseType.Ruby))
        starRuby.req.append((quality: TowerQuality.Chipped, type: TowerBaseType.Amethyst))
        
        specialTowers.append(starRuby)
        
        var uranium = SpecialTower()
        uranium.towerType = TowerType.Uranium238
        uranium.req.append((quality: TowerQuality.Perfect, type: TowerBaseType.Topaz))
        uranium.req.append((quality: TowerQuality.Flawed, type: TowerBaseType.Opal))
        uranium.req.append((quality: TowerQuality.Normal, type: TowerBaseType.Sapphire))
        
        specialTowers.append(uranium)
        
        var yellowSapphire = SpecialTower()
        yellowSapphire.towerType = TowerType.YellowSapphire
        yellowSapphire.req.append((quality: TowerQuality.Perfect, type: TowerBaseType.Sapphire))
        yellowSapphire.req.append((quality: TowerQuality.Flawless, type: TowerBaseType.Topaz))
        yellowSapphire.req.append((quality: TowerQuality.Flawless, type: TowerBaseType.Ruby))
        
        specialTowers.append(yellowSapphire)
    }
    
    func setUIButtons() {
        
        ui.hideButtons()
        
        if phase == .Select {
            
            if roundTowers.contains(selectedTower) {
                ui.keepButton.isHidden = false
                
                if checkCombine() {
                    ui.combineButton.isHidden = false
                }
                
                if checkSpecialCombineRound() {
                    ui.combineSpecialButton.isHidden = false
                }
            }

            if checkUpgradeable() {
                ui.upgradeTowerButton.isHidden = false
            }
            
            if selectedTower.towerType == TowerType.Rock {
                ui.removeButton.isHidden = false
            }
        } else if phase == .Wave {
            if checkSpecialCombinePlace() {
                ui.combineSpecialButton.isHidden = false
            }

            if checkUpgradeable() {
                ui.upgradeTowerButton.isHidden = false
            }
            
            if selectedTower.towerType == TowerType.Rock {
                ui.removeButton.isHidden = false
            }
        }
    }
    
    func checkCombine() -> Bool {
        var numCombine = 0
        
        for tower in roundTowers {
            if !tower.selected {
              
                if (selectedTower.towerQuality == tower.towerQuality) &&
                    (selectedTower.towerBaseType == tower.towerBaseType) {
                    
                    numCombine += 1
                }
            }
        }
        
        print("numCombine: \(numCombine)")
        
        if numCombine > 0 {
            return true
        } else {
            return false
        }
        
    }
    
    func checkSpecialCombineRound() -> Bool {

        for specialTower in specialTowers {
            var filledReqTowers = specialTower.req
            
            var filledTowers = [Tower]()
            
            for roundTower in roundTowers {
                
                var filledReqIndex = -1
                
                for (index, filledReq) in filledReqTowers.enumerated() {
                    if (roundTower.towerQuality == filledReq.quality) &&
                        (roundTower.towerBaseType == filledReq.type) {
                        
                        filledReqIndex = index
                        break
                    }
                }
                
                if filledReqIndex != -1 {
                    filledReqTowers.remove(at: filledReqIndex)
                    filledTowers.append(roundTower)
                }
                
            }
            
            if filledReqTowers.count == 0 {
                print("Special Tower Found")
                if filledTowers.contains(selectedTower) {
                    specialFoundTower = specialTower
                    return true
                }
            }
        }
        
        return false
    }
    
    func checkSpecialCombinePlace() -> Bool {
        
        if selectedTower != nil {
        
            for specialTower in specialTowers {
                var filledReqTowers = specialTower.req
                
                filledTowers = [Tower]()
                
                for tower in towers {
                    
                    var filledReqIndex = -1
                    
                    for (index, filledReq) in filledReqTowers.enumerated() {
                        if (tower.towerQuality == filledReq.quality) &&
                            (tower.towerBaseType == filledReq.type) {
                            
                            filledReqIndex = index
                            break
                        }
                    }
                    
                    if filledReqIndex != -1 {
                        filledReqTowers.remove(at: filledReqIndex)
                        filledTowers.append(tower)
                    }
                    
                    if filledReqTowers.count == 0 {
                        print("Special Tower Found")
                        if filledTowers.contains(selectedTower) {
                            specialFoundTower = specialTower
                            return true
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func checkUpgradeable() -> Bool {
        if selectedTower != nil {
            if selectedTower.upgradesTo != TowerType.Rock {
                return true
            }
        }
        
        return false
    }
    
    func findPath(flying: Bool) -> [Point] {
        var fullPath = [Point]()
        var waypoints = [Point]()

        waypoints.append(Point(x:  0, y: 35))
        waypoints.append(Point(x:  8, y: 35))
        waypoints.append(Point(x:  8, y: 18))
        waypoints.append(Point(x: 32, y: 18))
        waypoints.append(Point(x: 32, y: 34))
        waypoints.append(Point(x: 20, y: 34))
        waypoints.append(Point(x: 20, y:  6))
        waypoints.append(Point(x: 39, y:  6))

        if !flying {
            var prev = waypoints[0]
            var index = 1

            while index < waypoints.count {

                let curr = waypoints[index]
                let section: [Point] = map.findPath(prev.x, startY: prev.y, goalX: curr.x, goalY: curr.y)
                
                //Exit if any section returns empty path
                if section.count == 0 {
                    return []
                }

                fullPath += section.reversed()

                prev = curr
                index += 1
            }
            
            return fullPath
        } else {
            return waypoints
        }
    }

    func loadWave() {
        enemyIndex = 0
        creatingEnemies = true
        
        let wait = SKAction.wait(forDuration: 1.0)
        let run = SKAction.run {
            self.createEnemy()
        }
        
        self.run(SKAction.repeat(SKAction.sequence([wait, run]), count: 10),
                 completion: { self.creatingEnemies = false})
    }
    
    func createEnemy() {
        let enemy = Enemy()

        enemy.id = enemyIndex
        enemy.anchorPoint = CGPoint(x: 0, y: 0)
        enemy.position = CGPoint(x: 0, y: 35 * TILE_SIZE)
        enemy.zPosition = 2
        enemy.setSprite()
        enemy.setGame(gameScene: self)
        enemy.setPath(findPath(flying: enemy.flying))
        
        enemies.append(enemy)
        
        bg.addChild(enemy)
        
        flyingLevel = enemy.flying
        
        enemyIndex += 1
    }

    override func update(_ currentTime: TimeInterval) {
        var collision: Bool = false

        for tower in towers {

            var discards: [Enemy] = [Enemy]()

            for target in tower.targets {
                
                if target.isDead() {
                    discards.append(target)
                } else {
                    collision = checkCollision(tower.position, radius1: CGFloat(tower.calculateRange()),
                                               center2: target.position, radius2: 1)

                    if(!collision) {
                        discards.append(target)
                    }
                }
            }

            for discard in discards {
                let index = tower.targets.index(where: {$0.id == discard.id})
                tower.targets.remove(at: index!)
            }
            
            for enemy in enemies {
                if(tower.targets.count < tower.multiTargets) {
                    collision = checkCollision(tower.position, radius1: CGFloat(tower.calculateRange()),
                                               center2: enemy.position, radius2: 1)
                    
                    if(collision) {
                        
                        let enemyIndex = tower.targets.index(where: {$0.id == enemy.id})

                        if(enemyIndex == nil) {
                            tower.targets.append(enemy)
                        }
   
                    }
                }
                
                // Check Proximity auras of the tower
                if !flyingLevel && tower.proxAuraGround {
                    checkProximitySpeedAura(tower: tower, enemy: enemy)
                    checkProximityArmorAura(tower: tower, enemy: enemy)
                } else if flyingLevel && tower.proxAuraFlying {
                    checkProximitySpeedAura(tower: tower, enemy: enemy)
                    checkProximityArmorAura(tower: tower, enemy: enemy)
                }
            }
        }
        
        for enemy in enemies {
            let dest: CGPoint = CGPoint(x: enemy.currentDest.x, y: enemy.currentDest.y)
            
            collision = checkCollision(enemy.position, radius1: 1, center2: dest, radius2: 1)
            
            if(collision) {
                
                if(enemy.pathIndex < enemy.path.count) {
                    enemy.currentDest = CGPoint(x: enemy.path[enemy.pathIndex].x * TILE_SIZE, y: enemy.path[enemy.pathIndex].y * TILE_SIZE)
                    
                    enemy.pathIndex += 1
                } else {
                    print("Enemy reached the end")
                    removeEnemy(enemyId: enemy.id, killed: false)
                }
            }
            
            enemy.setPosition()
        }
    }

    func checkCollision(_ center1: CGPoint, radius1: CGFloat, center2: CGPoint, radius2: CGFloat) -> Bool {
        
        let xdiff: CGFloat = center1.x - center2.x
        let ydiff: CGFloat = center1.y - center2.y

        let dist: CGFloat = sqrt(xdiff * xdiff + ydiff * ydiff)

        if(dist <= radius1+radius2) {
            return true 
        } else {
            return false
        }
    }

    func checkTowerLocation(_ tileX: Int, tileY: Int) -> Tile {
       print("tileX,Y: " + String(tileX) + "," + String(tileY))
       let tile1 = map.getTile(x: tileX, y: tileY)
       let tile2 = map.getTile(x: tileX - 1, y: tileY)
       let tile3 = map.getTile(x: tileX, y: tileY - 1)
       let tile4 = map.getTile(x: tileX - 1, y: tileY - 1)

       if(tile1 == Tile.empty && tile2 == Tile.empty && tile3 == Tile.empty && tile4 == Tile.empty) {
           return Tile.empty
       } 

       if(tile1 == Tile.blocked || tile2 == Tile.blocked || tile3 == Tile.blocked || tile4 == Tile.blocked) {
           return Tile.blocked
       }

       return Tile.restricted
    }
    
    func checkAuras() {
        for auraTower in towers {
            if auraTower.bonusAura {
                for tower in towers {
                    
                    if auraTower.speedAuraOpalValue > 0 {
                        
                        if checkCollision(auraTower.position,
                                          radius1: CGFloat(auraTower.speedAuraOpalRange),
                                          center2: tower.position,
                                          radius2: 1) {
                            
                            tower.speedAuraOpalValue = auraTower.speedAuraOpalValue
                            
                        }
                    }
                    
                    if auraTower.damageAuraSpecialValue > 0 {
                        
                        if checkCollision(auraTower.position,
                                          radius1: CGFloat(auraTower.damageAuraSpecialRange),
                                          center2: tower.position,
                                          radius2: 1) {
                            
                            tower.damageAuraValue = auraTower.speedAuraOpalValue
                            
                        }
                    }
                }
            }
        }
    }
    
    func checkProximitySpeedAura(tower: Tower, enemy: Enemy) {
        if tower.proxAuraSpeedPenalty > enemy.auraSpeedPenaltyValue {
            //Apply initial penalty
            if checkCollision(tower.position,
                              radius1: CGFloat(tower.proxAuraRange),
                              center2: enemy.position,
                              radius2: 1) {
                enemy.applyAuraSpeedPenalty(penalty: tower.proxAuraSpeedPenalty)
            }
        } else if tower.proxAuraSpeedPenalty == enemy.auraSpeedPenaltyValue {
            //Check if aura needs to be removed
            if checkCollision(tower.position,
                              radius1: CGFloat(tower.proxAuraRange),
                              center2: enemy.position,
                              radius2: 1) {
                enemy.removeAuraSpeedPenalty()
            }
        }
    }
    
    func checkProximityArmorAura(tower: Tower, enemy: Enemy) {
        if tower.proxAuraArmorPenalty > enemy.auraArmorPenaltyValue {
            if checkCollision(tower.position,
                              radius1: CGFloat(tower.proxAuraRange),
                              center2: enemy.position,
                              radius2: 1) {
                enemy.applyAuraArmorPenalty(penalty: tower.proxAuraArmorPenalty)
            }
        } else if tower.proxAuraArmorPenalty > enemy.auraArmorPenaltyValue {
            //Check if aura needs to be removed
            if checkCollision(tower.position,
                              radius1: CGFloat(tower.proxAuraRange),
                              center2: enemy.position,
                              radius2: 1) {
                enemy.removeAuraArmorPenalty()
            }
        }
    }
    
    func initRestricted() {
        //Spawn point
        map.setRestricted(1, y: 35)
        map.setRestricted(1, y: 34)
        map.setRestricted(0, y: 35)
        map.setRestricted(0, y: 34)

        //1st corner
        map.setRestricted(6, y: 35)
        map.setRestricted(6, y: 34)
        map.setRestricted(5, y: 35)
        map.setRestricted(5, y: 34)

        map.setRestricted(8, y: 35)
        map.setRestricted(8, y: 34)
        map.setRestricted(7, y: 35)
        map.setRestricted(7, y: 34)

        map.setRestricted(10, y: 35)
        map.setRestricted(10, y: 34)
        map.setRestricted(9, y: 35)
        map.setRestricted(9, y: 34)

        map.setRestricted(8, y: 33)
        map.setRestricted(8, y: 32)
        map.setRestricted(7, y: 33)
        map.setRestricted(7, y: 32)

        //2nd corner
        map.setRestricted(8, y: 20)
        map.setRestricted(8, y: 19)
        map.setRestricted(7, y: 20)
        map.setRestricted(7, y: 19)

        map.setRestricted(8, y: 18)
        map.setRestricted(8, y: 17)
        map.setRestricted(7, y: 18)
        map.setRestricted(7, y: 17)      

        map.setRestricted(8, y: 16)
        map.setRestricted(8, y: 15)
        map.setRestricted(7, y: 16)
        map.setRestricted(7, y: 15)

        map.setRestricted(10, y: 18)
        map.setRestricted(10, y: 17)
        map.setRestricted(9, y: 18)
        map.setRestricted(9, y: 17)

        //3rd corner
        map.setRestricted(30, y: 18)
        map.setRestricted(30, y: 17)
        map.setRestricted(29, y: 18)
        map.setRestricted(29, y: 17)

        map.setRestricted(32, y: 18)
        map.setRestricted(32, y: 17)
        map.setRestricted(31, y: 18)
        map.setRestricted(31, y: 17)

        map.setRestricted(32, y: 20)
        map.setRestricted(32, y: 19)
        map.setRestricted(31, y: 20)
        map.setRestricted(31, y: 19)

        map.setRestricted(32, y: 16)
        map.setRestricted(32, y: 15)
        map.setRestricted(31, y: 16)
        map.setRestricted(31, y: 15)

        //4th corner
        map.setRestricted(30, y: 35)
        map.setRestricted(30, y: 34)
        map.setRestricted(29, y: 35)
        map.setRestricted(29, y: 34)

        map.setRestricted(32, y: 35)
        map.setRestricted(32, y: 34)
        map.setRestricted(31, y: 35)
        map.setRestricted(31, y: 34)

        map.setRestricted(34, y: 35)
        map.setRestricted(34, y: 34)
        map.setRestricted(33, y: 35)
        map.setRestricted(33, y: 34)

        map.setRestricted(32, y: 33)
        map.setRestricted(32, y: 32)
        map.setRestricted(31, y: 33)
        map.setRestricted(31, y: 32)

        //5th corner
        map.setRestricted(22, y: 35)
        map.setRestricted(22, y: 34)
        map.setRestricted(21, y: 35)
        map.setRestricted(21, y: 34)

        map.setRestricted(20, y: 35)
        map.setRestricted(20, y: 34)
        map.setRestricted(19, y: 35)
        map.setRestricted(19, y: 34)

        map.setRestricted(18, y: 35)
        map.setRestricted(18, y: 34)
        map.setRestricted(17, y: 35)
        map.setRestricted(17, y: 34)

        map.setRestricted(20, y: 33)
        map.setRestricted(20, y: 32)
        map.setRestricted(19, y: 33)
        map.setRestricted(19, y: 32)

        //6th corner
        map.setRestricted(22, y: 7)
        map.setRestricted(22, y: 6)
        map.setRestricted(21, y: 7)
        map.setRestricted(21, y: 6)

        map.setRestricted(20, y: 9)
        map.setRestricted(20, y: 8)
        map.setRestricted(19, y: 9)
        map.setRestricted(19, y: 8)

        map.setRestricted(18, y: 7)
        map.setRestricted(18, y: 6)
        map.setRestricted(17, y: 7)
        map.setRestricted(17, y: 6)

        map.setRestricted(20, y: 7)
        map.setRestricted(20, y: 6)
        map.setRestricted(19, y: 7)
        map.setRestricted(19, y: 6)

        //End point
        map.setRestricted(39, y: 7)
        map.setRestricted(39, y: 6)
    }
    
    func getUpgradeCost() -> Int {
        return 20 + 30 * qualityLevel
    }

    func setUpgradeChanceCost() {
        switch(qualityLevel)
        {
            case 0:
                chippedChance = 100;
                
                break;
            case 1:
                chippedChance = 70;
                flawedChance = 30;
                
                break;
            case 2:
                chippedChance = 60;
                flawedChance = 30;
                normalChance = 10;
                
                break;
            case 3:
                chippedChance = 50;
                flawedChance = 30;
                normalChance = 20;
                
                break;
            case 4:
                chippedChance = 40;
                flawedChance = 30;
                normalChance = 20;
                flawlessChance = 10;
                
                break;
            case 5:
                chippedChance = 30;
                flawedChance = 30;
                normalChance = 30;
                flawlessChance = 10;
                
                break;
            case 6:
                chippedChance = 20;
                flawedChance = 30;
                normalChance = 30;
                flawlessChance = 20;
                
                break;
            case 7:
                chippedChance = 10;
                flawedChance = 30;
                normalChance = 30;
                flawlessChance = 30;
                
                break;
            case 8:
                chippedChance = 0;
                flawedChance = 30;
                normalChance = 30;
                flawlessChance = 30;
                perfectChance = 10;
                
                break;
                
            default:
                chippedChance = 100;
                
        }
    }
    
    func getUpgradeText() -> String {
        var upgradeText = ""
        
        upgradeText += "Increase the chance to get better gems:\n"
        upgradeText += "Chipped: \(chippedChance)\n"
        upgradeText += "Flawed: \(flawedChance)\n"
        upgradeText += "Normal: \(normalChance)\n"
        upgradeText += "Flawless: \(flawlessChance)\n"
        upgradeText += "Perfect: \(perfectChance)\n"
        upgradeText += "Cost to Upgrade: \(getUpgradeCost()) gold"

        return upgradeText
    }
    
    func boundLayerPos(_ aNewPosition: CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -37))
        retval.y = CGFloat(min(retval.y, 0))
        retval.y = CGFloat(max(retval.y, -(bg.size.height) + winSize.height - 22))
        
        return retval
    }
    
    func panForTranslation(_ translation: CGPoint) {
        let position = bg.position
        let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        bg.position = self.boundLayerPos(aNewPosition)
    }
    
    func initRangeCircle() {
        rangeCircle = SKShapeNode(circleOfRadius: 1)
        rangeCircle.position = CGPoint(x: 0, y: 0)
        rangeCircle.strokeColor = .black
        rangeCircle.fillColor = .clear
        rangeCircle.isUserInteractionEnabled = false
        rangeCircle.name = "range"
        rangeCircle.zPosition = 2
        rangeCircle.isHidden = true
        
        bg.addChild(rangeCircle)

    }
    
    func drawRangeCircle(center: CGPoint, radius: CGFloat) {
        bg.removeChildren(in: [rangeCircle])
        rangeCircle = SKShapeNode(circleOfRadius: radius)
        
        rangeCircle.position = CGPoint(x: center.x + 13, y: center.y + 13)
        rangeCircle.strokeColor = .black
        rangeCircle.fillColor = .clear
        rangeCircle.isUserInteractionEnabled = false
        rangeCircle.name = "range"
        rangeCircle.zPosition = 2
        
        rangeCircle.isHidden = false
        bg.addChild(rangeCircle)
    }
    
    func drawCrit(critDamage: Int, enemyPos: CGPoint) {
        print(critDamage)
        let critDamageLabel = SKLabelNode(fontNamed: "Marker Felt")
        let labelPos : CGPoint = CGPoint(x: enemyPos.x + 5, y: enemyPos.y + 10)
        
        critDamageLabel.text = "\(critDamage)"
        critDamageLabel.fontColor = UIColor.red
        critDamageLabel.fontSize = 18
        critDamageLabel.horizontalAlignmentMode = .left
        critDamageLabel.position = labelPos
        critDamageLabel.zPosition = 2
        
        bg.addChild(critDamageLabel)
        
        let move = SKAction.move(to: CGPoint(x: labelPos.x, y: labelPos.y + 15), duration: 2)
        let fadeOut = SKAction.fadeOut(withDuration: 2)
        let group = SKAction.group([move, fadeOut])
        let remove = SKAction.removeFromParent()
        
        critDamageLabel.run(SKAction.repeat(SKAction.sequence([group, remove]), count: 1))
    }
    
    func aoeDamage(sourcePos: CGPoint, aoeRange: Int, aoeDamage: Int, iceSlowModifier: Double) {
        for enemy in enemies {
            let collision = checkCollision(sourcePos, radius1: CGFloat(aoeRange),
                                           center2: enemy.position, radius2: 1)
            
            if collision {
                if iceSlowModifier > 0 {
                    enemy.applyIceSlow(modifier: iceSlowModifier)
                }
                
                enemy.setDamage(damage: aoeDamage)
                enemy.setHpBar()
            }
        }
    
    }
    
    func uploadScore(name: String) {
        let currentDevice = DCDevice.current
        
        // check if DeviceCheck is supported by the current device
        if currentDevice.isSupported {

            currentDevice.generateToken(completionHandler: { (data, error) in
                if let token = data {
                    
                    var req = URLRequest(url: URL(string:"https://gemdefensegame.com/upload")!)
                    req.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    req.httpMethod = "POST"
                    
                    let packet = ["token": token.base64EncodedString(),
                                  "name": name,
                                  "score": self.score,
                                  "diff": self.diffLevel.rawValue,
                                  "level": gameLevel,
                                  "time": self.time] as [String : Any]
                    
                    let httpBody = try! JSONSerialization.data(withJSONObject: packet, options: [])
                    
                    req.httpBody = httpBody
                    
                    let sesh = URLSession(configuration: .default)
                    let task = sesh.dataTask(with: req, completionHandler: { (data, response, error) in
                        if let error = error {
                            print(error)
                        }
                        else if data != nil {
                            let response = response as? HTTPURLResponse
                            
                            if(response?.statusCode == 200) {
                                DispatchQueue.main.async {
                                    self.ui.lostSprite.isHidden = true
                                    self.nameField.isHidden = true
                                }
                            }
                        }
                    })
                    task.resume()
                    
                } else if let error = error{
                    print("Generate Token error:")
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    func startTimer () {
        if timer == nil {
            timer =  Timer.scheduledTimer(
                timeInterval: TimeInterval(1.0),
                target      : self,
                selector    : #selector(timerTick),
                userInfo    : nil,
                repeats     : true)
        }
    }

    func stopTimerTest() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func timerTick() {
        time += 1
        ui.setTimeLabel(text: String(time))
    }
    
    func updateScore() {
        var diffMulti:Int = 0
        var levelScore:Int = 0
        var tempScore:Int = 0
        var timeScore:Int = 0
        
        switch(diffLevel) {
        case .Easy:
            diffMulti = 1
            break
        case .Hard:
            diffMulti = 4
            break
        case .Survival:
            diffMulti = 16
            break
            
        default:
            diffMulti = 0
        }
    
        levelScore = gameLevel * gameLevel * gameLevel
        tempScore = levelScore * diffMulti
        timeScore = (Int(Double(tempScore) * 0.5)) / time
        score = tempScore + timeScore
    }
    
}
