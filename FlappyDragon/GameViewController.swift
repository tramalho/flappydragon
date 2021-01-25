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
import AVFoundation

class GameViewController: UIViewController {

    private var stage: SKView?
    private var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = view as? SKView {
            stage = view
            stage?.ignoresSiblingOrder = true
            presentScene()
            playMusic()
        }
    }

    private func presentScene() {
        let scene = GameScene(size: CGSize(width: 320, height: 568))
        scene.scaleMode = .aspectFill
        stage?.presentScene(scene)
    }
    
    private func playMusic() {
        
        if let music = Bundle.main.url(forResource: "music", withExtension: "m4a") {
            
            audioPlayer = try! AVAudioPlayer(contentsOf: music)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 0.05
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
