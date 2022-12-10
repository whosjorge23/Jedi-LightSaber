//
//  GameScene.swift
//  Jedi LightSaber
//
//  Created by Jorge Giannotta on 18/03/2020.
//  Copyright © 2020 Westcostyle. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sceneManagerDelegate : SceneManagerDelegate?
    
    var player : SKSpriteNode?
    var floor : SKSpriteNode?
    var lightSaber : SKSpriteNode?
    var rightButton : SKSpriteNode?
    var leftButton : SKSpriteNode?
    var shootButton : SKSpriteNode?
    var enemy : SKSpriteNode?
    var powerUP : SKSpriteNode?
    
    var powerUpTimer : Timer?
    
    var scoreLabel : SKLabelNode?
    var font = UIFont.boldSystemFont(ofSize: 30)
    
    var score : Int = 0 {
        didSet {
            self.scoreLabel?.text = "SCORE: \(self.score)"
            
        }
    }
    
    let playerCategory : UInt32 = 0x1 << 0
    let lightsaberCategory : UInt32 = 0x1 << 1
    let enemyCategory : UInt32 = 0x1 << 2
    let powerUPCategory : UInt32 = 0x1 << 3
    
    var lightsaberArray = ["lightsaberBlue","lightsaberGreen","lightsaberRed"]
    var playersArray = ["playerB","playerG","playerR"]
    
    var chosenLightSaber = "lightsaberClear"
    
    var enemySpeed = 1.0
    
    override func didMove(to view: SKView) {
        slideIn()
        floor = SKSpriteNode(imageNamed: "floor")
        floor?.zPosition = 0
        floor?.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(floor!)
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel?.text = "SCORE: 0"
        scoreLabel?.zPosition = 4
        scoreLabel?.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        scoreLabel?.fontColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        addChild(scoreLabel!)
        self.physicsWorld.contactDelegate = self
        createPlayer(color: "playerR")
        createLightSaber(color: "lightsaberRed")
        createButtons()
//        createEnemy()
        startTimers()
        chooseLightSaber()
        
    }
    
    func startTimers() {
        
        powerUpTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (timer) in
            if self.enemySpeed == 1.0 {
                self.createPowerUp()
            }
        })
    }
    
    func createPlayer(color : String) {
        
        player = SKSpriteNode(imageNamed: color)
        player?.position = CGPoint(x: frame.midX, y: frame.midY)
        player?.zPosition = 2
        player?.physicsBody = SKPhysicsBody(circleOfRadius: player!.size.width / 2)
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.collisionBitMask = 0
        player?.physicsBody?.contactTestBitMask = enemyCategory
        
        addChild(player!)
    }
    
    func chooseLightSaber() {
        
        let buttonsBG = SKSpriteNode(color: #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7), size: CGSize(width: frame.size.width, height: 50))
        buttonsBG.position = CGPoint(x: frame.midX, y: frame.maxY - 150)
        buttonsBG.zPosition = 4
        addChild(buttonsBG)
        
        let lightSaberButtonBlue = SKSpriteNode(imageNamed: "lightsaberBtnB")
        lightSaberButtonBlue.position = CGPoint(x: frame.midX, y: frame.maxY - 150)
        lightSaberButtonBlue.name = "LightSaberBlue"
        lightSaberButtonBlue.zPosition = 5
        addChild(lightSaberButtonBlue)
        
        let lightSaberButtonGreen = SKSpriteNode(imageNamed: "lightsaberBtnG")
        lightSaberButtonGreen.position = CGPoint(x: frame.midX - 150, y: frame.maxY - 150)
        lightSaberButtonGreen.name = "LightSaberGreen"
        lightSaberButtonGreen.zPosition = 5
        addChild(lightSaberButtonGreen)
        
        let lightSaberButtonRed = SKSpriteNode(imageNamed: "lightsaberBtnR")
        lightSaberButtonRed.position = CGPoint(x: frame.midX + 150, y: frame.maxY - 150)
        lightSaberButtonRed.name = "LightSaberRed"
        lightSaberButtonRed.zPosition = 5
        addChild(lightSaberButtonRed)
        
    }
    
    func createLightSaber(color : String) {
        
        lightSaber = SKSpriteNode(imageNamed: color)
        lightSaber?.position = CGPoint(x: (player?.position.x)!, y: (player?.position.y)! + 155)
        lightSaber?.zPosition = 1
        lightSaber?.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: (lightSaber?.size.width)!, height: (lightSaber?.size.height)!))
        lightSaber?.physicsBody?.affectedByGravity = false
        lightSaber?.physicsBody?.categoryBitMask = lightsaberCategory
        lightSaber?.physicsBody?.collisionBitMask = 0
        lightSaber?.physicsBody?.contactTestBitMask = enemyCategory
        player?.addChild(lightSaber!)
    }
    
    func createEnemy() {
        
        enemy = SKSpriteNode(imageNamed: "enemy")
        let enemyPositions : [CGPoint] = [
            CGPoint(x: self.frame.midX, y: self.frame.maxY),
            CGPoint(x: self.frame.minX, y: self.frame.maxY),
            CGPoint(x: self.frame.maxX, y: self.frame.maxY),
            CGPoint(x: self.frame.minX, y: self.frame.midY),
            CGPoint(x: self.frame.maxX, y: self.frame.midY),
            CGPoint(x: self.frame.minX, y: self.frame.minY),
            CGPoint(x: self.frame.midX, y: self.frame.minY),
            CGPoint(x: self.frame.maxX, y: self.frame.minY),
        ]
        
        enemy?.physicsBody = SKPhysicsBody(circleOfRadius: enemy!.size.width / 2)
        enemy?.physicsBody?.affectedByGravity = false
        enemy?.physicsBody?.categoryBitMask = enemyCategory
        enemy?.physicsBody?.collisionBitMask = lightsaberCategory
        enemy?.physicsBody?.contactTestBitMask = lightsaberCategory | playerCategory
        
        enemy?.position = enemyPositions.randomElement()!
        enemy?.zPosition = 3
        
//        enemy?.run(SKAction.playSoundFileNamed("drone.wav", waitForCompletion: false))
        enemy?.run(SKAction.repeatForever(SKAction.rotate(toAngle: 360, duration: 30)))
        
        addChild(enemy!)
    }
    
    func createPowerUp() {
        powerUP = SKSpriteNode(imageNamed: "powerUp")
        let powerUPPositions : [CGPoint] = [
            CGPoint(x: self.frame.midX, y: self.frame.maxY),
            CGPoint(x: self.frame.minX, y: self.frame.maxY),
            CGPoint(x: self.frame.maxX, y: self.frame.maxY),
            CGPoint(x: self.frame.minX, y: self.frame.midY),
            CGPoint(x: self.frame.maxX, y: self.frame.midY),
            CGPoint(x: self.frame.minX, y: self.frame.minY),
            CGPoint(x: self.frame.midX, y: self.frame.minY),
            CGPoint(x: self.frame.maxX, y: self.frame.minY),
        ]
        
        powerUP?.physicsBody = SKPhysicsBody(circleOfRadius: powerUP!.size.width / 2)
        powerUP?.physicsBody?.affectedByGravity = false
        powerUP?.physicsBody?.categoryBitMask = powerUPCategory
        powerUP?.physicsBody?.collisionBitMask = 0
        powerUP?.physicsBody?.contactTestBitMask = playerCategory
        
        powerUP?.position = powerUPPositions.randomElement()!
        powerUP?.zPosition = 3
        
        addChild(powerUP!)
    }
    
    func createButtons() {
        
        leftButton = SKSpriteNode(imageNamed: "leftButton")
        leftButton?.name = "LEFTBUTTON"
        leftButton?.position = CGPoint(x: frame.minX + 150, y: frame.minY + 200)
        leftButton?.zPosition = 7
        addChild(leftButton!)
        
        rightButton = SKSpriteNode(imageNamed: "rightButton")
        rightButton?.name = "RIGHTBUTTON"
        rightButton?.position = CGPoint(x: frame.maxX - 150, y: frame.minY + 200)
        rightButton?.zPosition = 7
        addChild(rightButton!)
        
        shootButton = SKSpriteNode(imageNamed: "shootButton")
        shootButton?.name = "SHOOTBUTTON"
        shootButton?.position = CGPoint(x: frame.midX, y: frame.minY + 200)
        shootButton?.zPosition = 7
        addChild(shootButton!)
        
    }
    
    func addEmitter() {
        let emitter = SKEmitterNode(fileNamed: "fireworks")
        emitter?.zPosition = 6
        emitter?.position = enemy!.position
        emitter?.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.run {
            emitter?.removeFromParent()
            }]))
        addChild(emitter!)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.previousLocation(in: self)
            let node = self.nodes(at: location).first
            
            if node?.name == "LEFTBUTTON" {
                print("LEFT")
                player?.run(SKAction.rotate(byAngle: 360, duration: 100))
                floor?.run(SKAction.rotate(byAngle: -360, duration: 300))
            }else if node?.name == "RIGHTBUTTON" {
                print("RIGHT")
                player?.run(SKAction.rotate(byAngle: -360, duration: 100))
                floor?.run(SKAction.rotate(byAngle: 360, duration: 300))
            }else if node?.name == "SHOOTBUTTON" {
                print("SHOOT")
                createEnemy()
            }else if node?.name == "LightSaberBlue" {
                print("LightSaberBlue")
                player?.removeFromParent()
                createPlayer(color: "playerB")
                createLightSaber(color: "lightsaberBlue")
            }else if node?.name == "LightSaberGreen" {
                print("LightSaberGreen")
                player?.removeFromParent()
                createPlayer(color: "playerG")
                createLightSaber(color: "lightsaberGreen")
            }else if node?.name == "LightSaberRed" {
                print("LightSaberRed")
                player?.removeFromParent()
                createPlayer(color: "playerR")
                createLightSaber(color: "lightsaberRed")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player?.removeAllActions()
        floor?.removeAllActions()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player?.removeAllActions()
        floor?.removeAllActions()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if enemy != nil {
        let dx = player!.position.x - enemy!.position.x
        let dy = player!.position.y - enemy!.position.y
        let angle = atan2(dy, dx)
        
        
        enemy!.zRotation = angle - 3 * .pi/2
        enemy?.run(SKAction.moveTo(x: player!.position.x, duration: enemySpeed))
        enemy?.run(SKAction.moveTo(y: player!.position.y, duration: enemySpeed))
        }
        powerUP?.run(SKAction.moveTo(x: player!.position.x, duration: 3))
        powerUP?.run(SKAction.moveTo(y: player!.position.y, duration: 3))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var playerBody:SKPhysicsBody
        var otherBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            playerBody = contact.bodyA
            otherBody = contact.bodyB
            
        }else {
            playerBody = contact.bodyB
            otherBody = contact.bodyA
        }
        
        if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == enemyCategory {
            print("GAME OVER")
            self.run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.run {
                otherBody.node?.removeFromParent()
                }]))
            playerBody.node?.removeFromParent()
            score = 0
        }
        else if playerBody.categoryBitMask == lightsaberCategory && otherBody.categoryBitMask == enemyCategory {
            print("ENEMY HIT")
            score += 1
            otherBody.node?.removeFromParent()
            addEmitter()
            enemySpeed = 1.0
        }
        else if playerBody.categoryBitMask == playerCategory && otherBody.categoryBitMask == powerUPCategory {
            print("POWERUP HIT")
            otherBody.node?.removeFromParent()
            enemy?.removeFromParent()
            enemySpeed = 3.0
        }
    }
    
    let blackView = UIView()
    let bodyLabel = UILabel()
//    let button1 : UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("LightSaber Green", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
////        button.addTarget(self, action: #selector(createLSPGreen), for: .touchUpInside)
//        button.backgroundColor = #colorLiteral(red: 0.01069241669, green: 0.4768451452, blue: 0.9655900598, alpha: 1)
//        button.layer.cornerRadius = 5
//        return button
//    }()
        
        func slideIn() {
            
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            view!.addSubview(blackView)
            blackView.frame = view!.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 1.5) {
                self.blackView.alpha = 1
            }
            
//            button1.frame = CGRect(x: frame.maxX / 3, y: frame.midY + 100, width: 150, height: 100)
//            blackView.addSubview(button1)
            
//            let stackView = UIStackView(arrangedSubviews: [button1,button1,button1])
//            stackView.axis = .vertical
//            stackView.frame = CGRect(x: frame.midX, y: frame.midY, width: 150, height: 100)
//
//            blackView.addSubview(stackView)
        }
        
        @objc func handleDismiss() {
            UIView.animate(withDuration: 1.5) {
                self.blackView.alpha = 0
            }
        }
        
//    @objc func createLSPGreen() {
////        player?.removeFromParent()
////        createPlayer(color: "playerG")
////        createLightSaber(color: "lightsaberGreen")
////
////        UIView.animate(withDuration: 1.5) {
////            self.blackView.alpha = 0
////        }
//        print("lightsaper pressed")
//    }
}
