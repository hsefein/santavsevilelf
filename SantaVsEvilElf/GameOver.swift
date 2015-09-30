//
//  GameOver.swift
//  SantaVsEvilElf
//
//  Created by Reaper on 24/09/2015.
//  Copyright © 2015 Reaper. All rights reserved.
//

import Foundation
import SpriteKit
import Social


class GameOver: SKScene {
    
    let won:Bool
//    var GameOverLabel = SKLabelNode!
    
    init(size: CGSize, won: Bool) {
        self.won = won
        super.init(size: size)
}
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}
    


    override func didMoveToView(view: SKView) {
        
        var background: SKSpriteNode
        if (won) {
            background = SKSpriteNode(imageNamed: "YouWin")
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.1),
                SKAction.playSoundFileNamed("win.wav",
                    waitForCompletion: false)
                ]))
        } else {
            background = SKSpriteNode(imageNamed: "background1")
            
            var youLose: SKLabelNode!
            
            youLose = SKLabelNode(fontNamed: "Chalkduster")
            youLose.text = "YOU LOSE!"
            youLose.fontSize = 100
            youLose.fontColor = SKColor.redColor()
            youLose.horizontalAlignmentMode = .Left
            youLose.position = CGPoint(x: 650, y: 950)
            youLose.zPosition = 1
            addChild(youLose)
            
            
            scoreLabel = SKLabelNode(fontNamed: "Helvatica")
            scoreLabel.text = "Presents Collected: \(score)"
            scoreLabel.fontSize = 60
            scoreLabel.fontColor = SKColor.redColor()
            scoreLabel.horizontalAlignmentMode = .Right
            scoreLabel.position = CGPoint(x: 1250, y: 750)
            scoreLabel.zPosition = 100
            addChild(scoreLabel)
            
            
            runAction(SKAction.sequence([
                SKAction.waitForDuration(0.1),
                SKAction.playSoundFileNamed("lose.wav",
                    waitForCompletion: false)
                ]))
//            GameOverLabel =
        }
        
        background.position =
            CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        
        // More here...
        let wait = SKAction.waitForDuration(3.0)
        let block = SKAction.runBlock {
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.runAction(SKAction.sequence([wait, block]))
        
    }
    
//    @IBAction func shareToFaceBook() {
//        var ShareToFaceBook: SLComposeViewController =
//        SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//        self.presentViewController(ShareToFaceBook, animated: true, completion: nil)
//    }
    
}