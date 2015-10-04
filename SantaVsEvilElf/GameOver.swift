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
import UIKit
import GameKit
import iAd
import AudioToolbox


class GameOver: SKScene {
    
    let won:Bool
    
    init(size: CGSize, won: Bool) {
        self.won = won
        super.init(size: size)
}
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}
    
    @IBOutlet weak var shareImg: UIImageView!

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
            youLose.text = "Merry Christmas!"
            youLose.fontSize = 100
            youLose.fontColor = SKColor.redColor()
            youLose.horizontalAlignmentMode = .Left
            youLose.position = CGPoint(x: 550, y: 950)
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
                SKAction.waitForDuration(0.2),
                SKAction.playSoundFileNamed("lose.mp3",
                    waitForCompletion: false)
                ]))
    

        }
        
        background.position =
            CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(background)
        
        let wait = SKAction.waitForDuration(7.0)
        let block = SKAction.runBlock {
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
            score = 0
        }
        self.runAction(SKAction.sequence([wait, block]))
        
    }
    
    
//    // FACEBOOK BUTTON
//    @IBAction func facebookButt(sender: AnyObject) {
//        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
//            let fb = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            fb.setInitialText("I have collected \(score) presents!")
//            fb.addImage(shareImg.image)
//            presentViewController(fb, animated: true, completion: nil)
//        }else {
//            let alert = UIAlertController(title: "Facebook",
//                message: "Please login to your Facebook account in Settings",
//                preferredStyle: .Alert)
//            
//            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
//            alert.addAction(action)
//            self.presentViewController, animated: true, completion: nil)
//        }
//    }
    

    
    
}