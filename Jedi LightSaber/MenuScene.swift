//
//  MenuScene.swift
//  Jedi LightSaber
//
//  Created by Jorge Giannotta on 22/04/2020.
//  Copyright © 2020 Westcostyle. All rights reserved.
//

import SpriteKit

var player = ""
var ls = ""

class MenuScene: SKScene {

    var sceneManagerDelegate : SceneManagerDelegate?
        
        
        override func didMove(to view: SKView) {
            setupMenu()
            
            scene?.backgroundColor = #colorLiteral(red: 0.156506598, green: 0.4688075185, blue: 0.6803125739, alpha: 1)
        }
        
        func setupMenu() {
            
    //        let background = SKSpriteNode(imageNamed: "backgroundScene0")
    //        background.position = CGPoint(x: frame.midX, y: frame.midY)
    //        background.aspectScaleTo(to: frame.size, width: true, multiplier: 1.0)
    //        background.zPosition = 1
    //        addChild(background)
            
            
            let playbutton = SpriteKitButton(defaultButtonImage: "playButton", action: gotoGameScene, index: 0)
            playbutton.position = CGPoint(x: frame.midX, y: frame.midY)
            playbutton.aspectScaleTo(to: frame.size, width: false, multiplier: 0.05)
            playbutton.zPosition = 10
            addChild(playbutton)
            
            let titleGame = SKLabelNode(fontNamed: "Helvetica")
            titleGame.text = "Jedi Training"
            titleGame.fontColor = #colorLiteral(red: 0.7537336349, green: 0.6949374676, blue: 0.4615763426, alpha: 1)
            titleGame.fontSize = 70.0
            titleGame.position = CGPoint(x: frame.midX, y: frame.midY + 0.2)
            titleGame.aspectScaleTo(to: frame.size, width: true, multiplier: 0.3)
            titleGame.zPosition = 10
            addChild(titleGame)
            
        }
        
        func gotoGameScene(_ : Int) {
            sceneManagerDelegate?.presentGameScene()
        }
        
    //    func gotoTutorialScene(_ : Int) {
    //        sceneManagerDelegate?.presentTutorialScene()
    //    }
}
