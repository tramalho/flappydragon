//
//  GameScene.swift
//  FlappyDragon
//
//  Created by Thiago Antonio Ramalho on 20/01/21.
//  Copyright © 2021 Tramalho. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var floor : SKSpriteNode!
    private var intro : SKSpriteNode!
    private var player : SKSpriteNode!
    
    private let gameArea: CGFloat = 410.0
    private let velocity = 100.0
    
    override func didMove(to view: SKView) {
        addBackground()
        addFloor()
        addIntro()
        addPlayer()
        addMoveFloor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    private func addBackground() {
        
        let position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        
        _ = createImageNode(zPosition: 0, imageName: "background", position: position)
    }
    
    private func addFloor() {
        
        floor = SKSpriteNode(imageNamed: "floor")
        
        let position = CGPoint(x: floor.size.width / 2, y: self.size.height - gameArea - floor.size.height / 2)
        
        floor.zPosition = 2
        floor.position = position
        
        addChild(floor!)
    }
    
    private func addIntro() {
        
        let position = CGPoint(x: self.size.width / 2, y:  self.size.height - 210)
        
        intro = createImageNode(zPosition: 3, imageName: "intro", position: position)
    }
    
    private func addPlayer() {
        
        let position = CGPoint(x: 60, y: self.size.height - gameArea / 2)
        
        player = createImageNode(zPosition: 4, imageName: "player1", position: position)
        
        var textures: [SKTexture] = []
        
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "player\(i)"))
        }
        
        let animation = SKAction.animate(with: textures, timePerFrame: 0.09)
        let repeatAction = SKAction.repeatForever(animation)
        
        player.run(repeatAction)
    }
    
    
    private func addMoveFloor() {
        
        let duration = Double(floor.size.width/2)/velocity
        
        let moveAction  = SKAction.moveBy(x: -(floor.size.width/2), y: 0, duration: duration)
        let resetAction = SKAction.moveBy(x: floor.size.width/2, y: 0, duration: 0)

        let sequenceAction = SKAction.sequence([moveAction, resetAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        floor.run(repeatAction)
    }
    
    private func createImageNode(zPosition: Int, imageName: String, position: CGPoint) -> SKSpriteNode {
        
        let skSpriteNode = SKSpriteNode(imageNamed: imageName)
        
        skSpriteNode.zPosition = CGFloat(zPosition)
        skSpriteNode.position = position
        
        addChild(skSpriteNode)
        
        return skSpriteNode
    }
}
