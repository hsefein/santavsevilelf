//
//  MainMenu.swift
//  SantaVsEvilElf
//
//  Created by Reaper on 26/09/2015.
//  Copyright © 2015 Reaper. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "MainMenu")
        background.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        self.addChild(background)
    }
    
    func sceneTapped() {
        let myScence = GameScene(size: self.size)
        myScence.scaleMode = scaleMode
        let reveal = SKTransition.doorsCloseHorizontalWithDuration(1.5)
        self.view?.presentScene(myScence, transition: reveal)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        sceneTapped()
    }
}
