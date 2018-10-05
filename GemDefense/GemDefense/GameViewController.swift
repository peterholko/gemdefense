//
//  GameViewController.swift
//  GemDefense
//
//  Created by Peter Holko on 2016-05-21.
//  Copyright (c) 2016 Peter Holko. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var skView : SKView!
    var scene : GameScene!
    var camera : SKCameraNode = SKCameraNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = GameScene(size: view.bounds.size)
        
        skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    
        scene.setupLabel()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
