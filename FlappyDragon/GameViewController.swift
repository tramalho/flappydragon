//
//  GameViewController.swift
//  FlappyDragon
//
//  Created by Thiago Antonio Ramalho on 20/01/21.
//  Copyright © 2021 Tramalho. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    private var stage: SKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = view as? SKView {
            stage = view
            stage?.ignoresSiblingOrder = true
            presentScene()
        }
    }

    private func presentScene() {
        let scene = GameScene(size: CGSize(width: 320, height: 568))
        scene.scaleMode = .aspectFill
        stage?.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
