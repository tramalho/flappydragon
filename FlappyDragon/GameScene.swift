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
    
    private var playerCategory: UInt32 = 1
    private var enemyCategory: UInt32 = 2
    private var scoreCategory: UInt32 = 4
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
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
        
        let node = createImageNode(zPosition: 0, imageName: "background", position: position)
        
        addChild(node)
    }
    
    private func addFloor() {
        
        floor = createImageNode(zPosition: 2, imageName: "floor")
        floor.position = CGPoint(x: floor.size.width / 2, y: self.size.height - gameArea - floor.size.height / 2)
        
        addChild(floor!)
        
        let invisibleFloor = createRigidBody(position: CGPoint(x: self.size.width/2, y: self.size.height - gameArea))
        invisibleFloor.physicsBody?.contactTestBitMask = playerCategory
        invisibleFloor.physicsBody?.categoryBitMask = enemyCategory
        
        addChild(invisibleFloor)
        
        let invisibleRoof = createRigidBody(position: CGPoint(x: self.size.width/2, y: self.size.height))
        
        addChild(invisibleRoof)
    }
    
    private func addIntro() {
        
        let position = CGPoint(x: self.size.width / 2, y:  self.size.height - 210)
        
        intro = createImageNode(zPosition: 3, imageName: "intro", position: position)
        
        addChild(intro)
    }
    
    private func addPlayer() {
        
        let position = CGPoint(x: 80, y: self.size.height - gameArea / 2)
        
        player = createImageNode(zPosition: 4, imageName: "player1", position: position)
        
        addChild(player)
        
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
    
    private func createImageNode(zPosition: Int, imageName: String, position: CGPoint? = nil) -> SKSpriteNode {
        
        let skSpriteNode = SKSpriteNode(imageNamed: imageName)
        
        skSpriteNode.zPosition = CGFloat(zPosition)
        
        if let position = position {
            skSpriteNode.position = position
        }
        
        return skSpriteNode
    }
    
    private func startingState() {
        intro.removeFromParent()
        addScore()
        initPlayer()
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { (Timer) in
            self.spawnEnemies()
        }
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
        player.physicsBody?.collisionBitMask = enemyCategory
        player.physicsBody?.contactTestBitMask = scoreCategory
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
    
    private func createRigidBody(position: CGPoint) -> SKNode {
        
        let invisibleSize = CGSize(width: self.size.width, height: 1)
        
        let node = createNode(size: invisibleSize)
        node.position = position

        return node
    }
    
    private func createNode(size: CGSize) -> SKNode {
        
        let node = SKNode()
        
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = false
        node.zPosition = 2
        
        return node
    }
    
    private func spawnEnemies() {
        
        let initialPosition = CGFloat(arc4random_uniform(132) + 74)
        let enemyNumber = Int(arc4random_uniform(4) + 1)
        let enemyDistance = self.player.size.height * 2.5
        
        let enemyTop = createEnemy(imageName: "enemytop\(enemyNumber)")
        let enemyBottom = createEnemy(imageName: "enemybottom\(enemyNumber)")
        let laser = createNode(size: CGSize(width: 1, height: enemyDistance))
        laser.physicsBody?.categoryBitMask = scoreCategory
        
        let enemyWidth: CGFloat = self.size.width + enemyTop.size.width / 2
        
        enemyTop.position = CGPoint(x: enemyWidth, y: self.size.height - initialPosition + enemyTop.size.height/2)
        enemyBottom.position = CGPoint(x: enemyWidth, y: enemyTop.position.y - enemyTop.size.height - enemyDistance)
        
        laser.position = CGPoint(x: enemyTop.position.x + enemyTop.size.width / 2, y: enemyTop.position.y - enemyTop.size.height / 2 - enemyDistance / 2)

        let distance = self.size.width + enemyTop.size.width
        let duration = Double(distance) / velocity
        
        let moveAction = SKAction.moveBy(x: -distance, y: 0, duration: duration)
        let removeAction = SKAction.removeFromParent()
        let sequece = SKAction.sequence([moveAction, removeAction])
        
        enemyTop.run(sequece)
        enemyBottom.run(sequece)
        laser.run(sequece)
        
        addChild(enemyTop)
        addChild(enemyBottom)
        addChild(laser)
    }
    
    private func createEnemy(imageName: String) -> SKSpriteNode {
        
        let enemy = createImageNode(zPosition: 1, imageName: imageName)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.contactTestBitMask = playerCategory
        enemy.physicsBody?.categoryBitMask = enemyCategory
        
        return enemy
        
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let categoriesBitmask:[UInt32] = [contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask]
        
        if gameStatus == .running {
            
            if categoriesBitmask.contains(scoreCategory) {
                score += 1
                labelScore.text = "Score:\(score)"
                
            } else if categoriesBitmask.contains(enemyCategory) {
                print("enemy collision")
            }
        }
        
    }
}
