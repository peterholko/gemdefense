//
//  GDButton.swift
//  GemDefense
//
//  Created by Peter Holko on 2016-10-01.
//  Copyright © 2016 Peter Holko. All rights reserved.
//

import SpriteKit

class GDButton : SKNode {

    var restButton: SKSpriteNode
    var activeButton: SKSpriteNode
    var action:  () -> Void
    
    init(restImage: String, activeImage: String, buttonAction: @escaping () -> Void) {
        restButton = SKSpriteNode(imageNamed: restImage)
        activeButton = SKSpriteNode(imageNamed: activeImage)
        
        activeButton.isHidden = true
        action = buttonAction
        
        super.init()
        
        isUserInteractionEnabled = true
        
        restButton.anchorPoint = CGPoint(x: 0, y: 0)
        activeButton.anchorPoint = CGPoint(x: 0, y: 0)
        
        addChild(restButton)
        addChild(activeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeButton.isHidden = false
        restButton.isHidden = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if restButton.contains(location) {
                activeButton.isHidden = false
                restButton.isHidden = true
            } else {
                activeButton.isHidden = true
                restButton.isHidden = false
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if restButton.contains(location) {
                action()
            }
            
            activeButton.isHidden = true
            restButton.isHidden = false
        }
    }
    
}
