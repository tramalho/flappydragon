//
//  GameScene.swift
//  FlappyDragon
//
//  Created by Thiago Antonio Ramalho on 20/01/21.
//  Copyright © 2021 Tramalho. All rights reserved.
//

import SpriteKit
import GameplayKit

private enum GameStatus {
    case starting
    case running
    case finishied
}

class GameScene: SKScene {
    
    private var floor : SKSpriteNode!
    private var intro : SKSpriteNode!
    private var player : SKSpriteNode!
    private var labelScore : SKLabelNode!
    
    private let gameArea: CGFloat = 410.0
    private let velocity = 100.0
    private let flyForce = 30
    private var score = 0
    private var gameStatus: GameStatus = .starting
    
    override func didMove(to view: SKView) {
        addBackground()
        addFloor()
        addIntro()
        addPlayer()
        addMoveFloor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameStatus {
            case .starting:
                startingState()
            case .running:
                runningState()
            case .finishied:
                print("finishied")
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if gameStatus == .running {
            updateRotation()
        }
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
        
        let position = CGPoint(x: 80, y: self.size.height - gameArea / 2)
        
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
    
    private func addScore() {
        
        labelScore = SKLabelNode(fontNamed: "Chalkduster")
        
        labelScore.text = "Score:\(score)"
        labelScore.fontSize = 30
        labelScore.alpha = 0.8
        labelScore.zPosition = 5
        let position = CGPoint(x: self.size.width - (labelScore.frame.width), y: self.size.height - 70)
        
        labelScore.position = position
        
        addChild(labelScore!)
    }
    
    private func createImageNode(zPosition: Int, imageName: String, position: CGPoint) -> SKSpriteNode {
        
        let skSpriteNode = SKSpriteNode(imageNamed: imageName)
        
        skSpriteNode.zPosition = CGFloat(zPosition)
        skSpriteNode.position = position
        
        addChild(skSpriteNode)
        
        return skSpriteNode
    }
    
    private func startingState() {
        intro.removeFromParent()
        addScore()
        initPlayer()
        gameStatus = .running
    }
    
    private func runningState() {
        applyGravityForce()
        gameStatus = .running
    }
    
    private func initPlayer() {
        
        player?.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2 - 10)
        player?.physicsBody?.isDynamic = true
        player?.physicsBody?.allowsRotation = true
        applyGravityForce()
    }
    
    private func applyGravityForce() {
        player?.physicsBody?.velocity = CGVector.zero
        player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: flyForce))
    }
    
    private func updateRotation() {
        if let velocity = player?.physicsBody?.velocity {
            player.zRotation = velocity.dy * 0.001
        }
    }
}
