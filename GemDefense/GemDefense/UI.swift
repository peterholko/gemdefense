//
//  UI.swift
//  GemDefense
//
//  Created by Peter Holko on 2016-10-01.
//  Copyright © 2016 Peter Holko. All rights reserved.
//

import Foundation
import SpriteKit

class UI : SKNode {
    var game : GameScene!
    var info : SKMultilineLabel!
    
    var diffLabel : SKLabelNode!
    var levelLabel : SKLabelNode!
    var livesLabel : SKLabelNode!
    var goldLabel : SKLabelNode!
    var timeLabel : SKLabelNode!
    var scoreLabel : SKLabelNode!
    
    var panelSprite = SKSpriteNode(imageNamed: "panel")
    var textareaSprite = SKSpriteNode(imageNamed: "textarea")
    var topmenuSprite = SKSpriteNode(imageNamed: "top_menu")
    var upgradeTextAreaSprite = SKSpriteNode(imageNamed: "textarea")
    var buyLivesTextAreaSprite = SKSpriteNode(imageNamed: "textarea")
    var resetGameSprite = SKSpriteNode(imageNamed: "resetgame1")
    
    var cannotBuildSprite = SKSpriteNode(imageNamed: "cannotbuildthere")
    var blockingSprite = SKSpriteNode(imageNamed: "blocking")
    var lostSprite = SKSpriteNode(imageNamed: "lost")
    
    var resetButton: GDButton!
    var resetYesButton: GDButton!
    var resetNoButton: GDButton!
    var buyLivesButton: GDButton!
    var buyLivesYesButton: GDButton!
    var buyLivesNoButton: GDButton!
    
    var placeButton: GDButton!
    var keepButton: GDButton!
    var combineButton : GDButton!
    var combineSpecialButton : GDButton!
    var upgradeTowerButton: GDButton!
    var removeButton: GDButton!
    var upgradeButton: GDButton!
    var upgradeYesButton : GDButton!
    var upgradeNoButton : GDButton!
    var submitScoreButton : GDButton!
    
    var easyButton : GDButton!
    var hardButton : GDButton!
    var survivalButton : GDButton!
    
    let bounds = UIScreen.main.bounds
    var sheight : CGFloat = 0.0
    var swidth : CGFloat = 0.0
    
    override init() {
        super.init()

        sheight = bounds.size.height
        swidth = bounds.size.width
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPanel() {
        let panelX = swidth - panelSprite.size.width
        
        panelSprite.anchorPoint = CGPoint(x: 0, y: 0)
        panelSprite.position = CGPoint(x: panelX, y: 0)
        
        addChild(panelSprite)
        
        //let textAreaX = (panelSprite.size.width - textareaSprite.size.width) / 2
        
        textareaSprite.position = CGPoint(x: 5 + (textareaSprite.size.width / 2), y: 250)

        textareaSprite.zPosition = 1
        panelSprite.addChild(textareaSprite)
    }
    
    func setTopMenu() {
        topmenuSprite.anchorPoint = CGPoint(x: 0, y: 0)
        topmenuSprite.position = CGPoint(x: 0, y: sheight - topmenuSprite.size.height)
        
        addChild(topmenuSprite)
    }
    
    func initResetButton(resetFunc: @escaping () -> Void) {
        resetButton = GDButton(restImage: "resetsmall1", activeImage: "resetsmall2", buttonAction: resetFunc)
        
        let resetX = (panelSprite.size.width - resetButton.activeButton.size.width) / 2 - 50
        let resetY = 320 + resetButton.activeButton.size.height / 2
        
        resetButton.position = CGPoint(x: resetX, y: resetY)
        resetButton.zPosition = 1
        resetButton.isHidden = true
        
        panelSprite.addChild(resetButton)
    }
    
    func initBuyLivesButton(buyLivesFunc: @escaping () -> Void) {
        buyLivesButton = GDButton(restImage: "buylives_small1", activeImage: "buylives_small2", buttonAction: buyLivesFunc)
        
        let buyLivesX = (panelSprite.size.width - buyLivesButton.activeButton.size.width) / 2 + 50
        let buyLivesY = 320 + buyLivesButton.activeButton.size.height / 2
        
        buyLivesButton.position = CGPoint(x: buyLivesX, y: buyLivesY)
        buyLivesButton.zPosition = 1
        buyLivesButton.isHidden = true
        
        panelSprite.addChild(buyLivesButton)
    }

    func initPlaceButton(placeFunc: @escaping () -> Void) {
        placeButton = GDButton(restImage: "placegem1", activeImage: "placegem2", buttonAction: placeFunc)
        
        let placeX = (panelSprite.size.width - placeButton.activeButton.size.width) / 2
        let placeY = 55 + placeButton.activeButton.size.height / 2
        
        placeButton.position = CGPoint(x: placeX, y: placeY)
        placeButton.zPosition = 1
        placeButton.isHidden = true
        
        panelSprite.addChild(placeButton)
    }
    
    func initKeepButton(keepFunc: @escaping () -> Void) {
        keepButton = GDButton(restImage: "keep1", activeImage: "keep2", buttonAction: keepFunc)
        
        let keepX = (panelSprite.size.width - keepButton.activeButton.size.width) / 2
        let keepY = 55 + keepButton.activeButton.size.height / 2
        
        keepButton.position = CGPoint(x: keepX, y: keepY)
        keepButton.zPosition = 1
        keepButton.isHidden = true
        
        panelSprite.addChild(keepButton)
    }
    
    func initCombineButton(combineFunc: @escaping () -> Void) {
        combineButton = GDButton(restImage: "combine1", activeImage: "combine2", buttonAction: combineFunc)
        
        let combineX = (panelSprite.size.width - combineButton.activeButton.size.width) / 2
        let combineY = 15 + combineButton.activeButton.size.height / 2
        
        combineButton.position = CGPoint(x: combineX, y: combineY)
        combineButton.zPosition = 1
        combineButton.isHidden = true
        
        panelSprite.addChild(combineButton)
    }
    
    func initCombineSpecialButton(combineSpecialFunc: @escaping () -> Void) {
        combineSpecialButton = GDButton(restImage: "combinespecial1", activeImage: "combinespecial2", buttonAction: combineSpecialFunc)
        
        let combineX = (panelSprite.size.width - combineSpecialButton.activeButton.size.width) / 2
        let combineY = 98 + combineSpecialButton.activeButton.size.height / 2
        
        combineSpecialButton.position = CGPoint(x: combineX, y: combineY)
        combineSpecialButton.zPosition = 1
        combineSpecialButton.isHidden = true
        
        panelSprite.addChild(combineSpecialButton)
    }
    
    func initUpgradeTowerButton(upgradeTowerFunc: @escaping () -> Void) {
        upgradeTowerButton = GDButton(restImage: "upgradegem1", activeImage: "upgradegem2", buttonAction: upgradeTowerFunc)
        
        let upgradeX = (panelSprite.size.width - upgradeTowerButton.activeButton.size.width) / 2
        let upgradeY = 98 + upgradeTowerButton.activeButton.size.height / 2
        
        upgradeTowerButton.position = CGPoint(x: upgradeX, y: upgradeY)
        upgradeTowerButton.zPosition = 1
        upgradeTowerButton.isHidden = true
        
        panelSprite.addChild(upgradeTowerButton)
    }
    
    func initRemoveButton(removeFunc: @escaping () -> Void) {
        removeButton = GDButton(restImage: "removegem1", activeImage: "removegem2", buttonAction: removeFunc)
        
        let removeX = (panelSprite.size.width - removeButton.activeButton.size.width) / 2
        let removeY = 98 + removeButton.activeButton.size.height / 2
        
        removeButton.position = CGPoint(x: removeX, y: removeY)
        removeButton.zPosition = 1
        removeButton.isHidden = true
        
        panelSprite.addChild(removeButton)
    }
    
    func initUpgradeButton(upgradeFunc: @escaping () -> Void) {
        upgradeButton = GDButton(restImage: "upgradechances1", activeImage: "upgradechances2", buttonAction: upgradeFunc)
        
        let upgradeX = (panelSprite.size.width - upgradeButton.activeButton.size.width) / 2
        let upgradeY = 98 + upgradeButton.activeButton.size.height / 2
        
        upgradeButton.position = CGPoint(x: upgradeX, y: upgradeY)
        upgradeButton.zPosition = 1
        upgradeButton.isHidden = true
        
        panelSprite.addChild(upgradeButton)
    }
    
    func initUpgradeYesButton(upgradeYesFunc: @escaping () -> Void) {
        upgradeYesButton = GDButton(restImage: "yes1", activeImage: "yes2", buttonAction: upgradeYesFunc)
        
        let upgradeX = -50
        let upgradeY = -120
        
        upgradeYesButton.position = CGPoint(x: upgradeX, y: upgradeY)
        upgradeYesButton.zPosition = 1
        
        upgradeTextAreaSprite.addChild(upgradeYesButton)
    }
    
    func initUpgradeNoButton(upgradeNoFunc: @escaping () -> Void) {
        upgradeNoButton = GDButton(restImage: "no1", activeImage: "no2", buttonAction: upgradeNoFunc)
        
        let upgradeX = 7
        let upgradeY = -120
        
        upgradeNoButton.position = CGPoint(x: upgradeX, y: upgradeY)
        upgradeNoButton.zPosition = 1
        
        upgradeTextAreaSprite.addChild(upgradeNoButton)
    }
    
    func initBuyLivesYesButton(buyLivesYesFunc: @escaping () -> Void) {
        buyLivesYesButton = GDButton(restImage: "yes1", activeImage: "yes2", buttonAction: buyLivesYesFunc)
        
        let x = -50
        let y = -120
        
        buyLivesYesButton.position = CGPoint(x: x, y: y)
        buyLivesYesButton.zPosition = 1
        
        buyLivesTextAreaSprite.addChild(buyLivesYesButton)
    }
    
    func initBuyLivesNoButton(buyLivesNoFunc: @escaping () -> Void) {
        buyLivesNoButton = GDButton(restImage: "no1", activeImage: "no2", buttonAction: buyLivesNoFunc)
        
        let x = 7
        let y = -120
        
        buyLivesNoButton.position = CGPoint(x: x, y: y)
        buyLivesNoButton.zPosition = 1
        
        buyLivesTextAreaSprite.addChild(buyLivesNoButton)
    }
    
    func initResetYesButton(resetYesFunc: @escaping () -> Void) {
        resetYesButton = GDButton(restImage: "yes1", activeImage: "yes2", buttonAction: resetYesFunc)
        
        let resetX = -50
        let resetY = -120
        
        resetYesButton.position = CGPoint(x: resetX, y: resetY)
        resetYesButton.zPosition = 1
        
        resetGameSprite.addChild(resetYesButton)
    }
    
    func initResetNoButton(resetNoFunc: @escaping () -> Void) {
        resetNoButton = GDButton(restImage: "no1", activeImage: "no2", buttonAction: resetNoFunc)
        
        let resetX = 7
        let resetY = -120
        
        resetNoButton.position = CGPoint(x: resetX, y: resetY)
        resetNoButton.zPosition = 1
        
        resetGameSprite.addChild(resetNoButton)
    }
    
    func initSubmitScoreButton(submitScoreFunc: @escaping () -> Void) {
        submitScoreButton = GDButton(restImage: "submitscore1", activeImage: "submitscore2", buttonAction: submitScoreFunc)
        
        let submitX = -75
        let submitY = -60
        
        submitScoreButton.position = CGPoint(x: submitX, y: submitY)
        submitScoreButton.zPosition = 1
        
        lostSprite.addChild(submitScoreButton)
    }
    
    func initUpgradePopup() {
        upgradeTextAreaSprite.position = CGPoint(x: swidth / 2 - 91, y: sheight / 2 + 15)
        
        upgradeTextAreaSprite.zPosition = 1
        upgradeTextAreaSprite.isHidden = true
        
        addChild(upgradeTextAreaSprite)
    }
    
    func initResetPopup() {
        resetGameSprite.position = CGPoint(x: swidth / 2 - 91, y: sheight / 2 + 15)
        
        resetGameSprite.zPosition = 1
        resetGameSprite.isHidden = true
        
        addChild(resetGameSprite)
    }
    
    func initBuyLivesPopup() {
        buyLivesTextAreaSprite.position = CGPoint(x: swidth / 2 - 91, y: sheight / 2 + 15)
        
        buyLivesTextAreaSprite.zPosition = 1
        buyLivesTextAreaSprite.isHidden = true
        
        addChild(buyLivesTextAreaSprite)
    }
    
    func initLostPopup() {
        lostSprite.position = CGPoint(x: swidth / 2 - 3, y: sheight / 2 + 37)
        
        lostSprite.zPosition = 1
        lostSprite.isHidden = true
        
        addChild(lostSprite)
    }
    
    func initInfoPopups() {
        cannotBuildSprite.position = CGPoint(x: swidth / 2 - 91, y: sheight / 2 + 15)
        blockingSprite.position = CGPoint(x: swidth / 2 - 91, y: sheight / 2 + 15)
        
        cannotBuildSprite.zPosition = 1
        blockingSprite.zPosition = 1
        
        cannotBuildSprite.isHidden = true
        blockingSprite.isHidden = true
        
        addChild(cannotBuildSprite)
        addChild(blockingSprite)
    }
    
    func initEasyButton(easyFunc: @escaping () -> Void) {
        easyButton = GDButton(restImage: "easy1", activeImage: "easy2", buttonAction: easyFunc)
        
        easyButton.position = CGPoint(x: swidth / 2 - 91, y: sheight / 2 + 15)
        easyButton.zPosition = 1
        easyButton.isHidden = true
        
        addChild(easyButton)
    }
    
    func initHardButton(hardFunc: @escaping () -> Void) {
        hardButton = GDButton(restImage: "hard1", activeImage: "hard2", buttonAction: hardFunc)
        
        hardButton.position = CGPoint(x: swidth / 2 - 91, y: sheight / 2 - 30)
        hardButton.zPosition = 1
        hardButton.isHidden = true
        
        addChild(hardButton)
    }
    
    func initSurvivalButton(survivalFunc: @escaping () -> Void) {
        survivalButton = GDButton(restImage: "survival1", activeImage: "survival2", buttonAction: survivalFunc)
        
        survivalButton.position = CGPoint(x: swidth / 2 - 91, y: sheight / 2 - 75)
        survivalButton.zPosition = 1
        survivalButton.isHidden = true
        
        addChild(survivalButton)
    }
    
    func initTopMenuText() {
        diffLabel = createTopMenuLabel(pos: CGPoint(x: 5, y: 5))
        levelLabel = createTopMenuLabel(pos: CGPoint(x: 100, y: 5))
        livesLabel = createTopMenuLabel(pos: CGPoint(x: 200, y: 5))
        goldLabel = createTopMenuLabel(pos: CGPoint(x: 300, y: 5))
        timeLabel = createTopMenuLabel(pos: CGPoint(x: 400, y: 5))
        scoreLabel = createTopMenuLabel(pos: CGPoint(x: 500, y: 5))
    }
    
    func createTopMenuLabel(pos: CGPoint) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Marker Felt")
        label.color = UIColor.white
        label.fontSize = 16
        label.horizontalAlignmentMode = .left
        label.position = pos
        label.zPosition = 1
        
        topmenuSprite.addChild(label)
        
        return label
    }
    
    func setDiffLabel(text: String) {
        diffLabel.text = text
    }
    
    func setLevelLabel(text: String) {
        levelLabel.text = "Level: \(text)"
    }
    
    func setLivesLabel(text: String) {
        livesLabel.text = "Lives: \(text)"
    }
    
    func setGoldLabel(text: String) {
        goldLabel.text = "Gold: \(text)"
    }
    
    func setTimeLabel(text: String) {
        timeLabel.text = "Time: \(text)"
    }
    
    func setScoreLabel(text: String) {
        scoreLabel.text = "Score: \(text)"
    }
    
    func showCannotBuildThere() {
        cannotBuildSprite.isHidden = false
        
        let wait = SKAction.wait(forDuration: 2)
        let run = SKAction.run {
            self.cannotBuildSprite.isHidden = true
        }
        
        self.run(SKAction.repeat(SKAction.sequence([wait, run]), count: 1))
    }
    
    func showBlocking() {
        blockingSprite.isHidden = false
        
        let wait = SKAction.wait(forDuration: 2)
        let run = SKAction.run {
            self.blockingSprite.isHidden = true
        }
        
        self.run(SKAction.repeat(SKAction.sequence([wait, run]), count: 1))
    }
    
    func hideButtons() {
        placeButton.isHidden = true
        keepButton.isHidden = true
        combineButton.isHidden = true
        combineSpecialButton.isHidden = true
        upgradeTowerButton.isHidden = true
        upgradeButton.isHidden = true
        removeButton.isHidden = true
    }
    
    func hideDiffButtons() {
        easyButton.isHidden = true
        hardButton.isHidden = true
        survivalButton.isHidden = true
    }
}
