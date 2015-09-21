//
//  GameScene.swift
//  SantaVsEvilElf
//
//  Created by Reaper on 17/09/2015.
//  Copyright (c) 2015 Reaper. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let santa: SKSpriteNode = SKSpriteNode(imageNamed: "santa1")
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    let santaMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPointZero
    let playableRect: CGRect
    var lastTouchLocation: CGPoint?
    let santaRotateRadiansPerSec:CGFloat = 4.0 * π
    let santaAnimation: SKAction
    let presentCollisionSound: SKAction = SKAction.playSoundFileNamed(
        "hitCat.wav", waitForCompletion: false)
    let enemyCollisionSound: SKAction = SKAction.playSoundFileNamed(
        "hitCatLady.wav", waitForCompletion: false)
    var invincible = false
    let presentMovePointsPerSec:CGFloat = 480.0
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var santaLivies: SKLabelNode!
    var life: Int = 5 {
        didSet {
            santaLivies.text = "Life: \(life)"
        }
    }
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin,
            width: size.width,
            height: playableHeight)
        
        var textures:[SKTexture] = []
       
        for i in 1...8 {
            textures.append(SKTexture(imageNamed: "santa\(i)"))
        }
        
        textures.append(textures[2])
        textures.append(textures[1])
        
        santaAnimation = SKAction.repeatActionForever(
            SKAction.animateWithTextures(textures, timePerFrame: 0.1))
        
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, playableRect)
        shape.path = path
        shape.strokeColor = SKColor.redColor()
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.whiteColor()
        
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1
        addChild(background)
        
        santa.position = CGPoint(x: 400, y: 400)
        //zombie.runAction(SKAction.repeatActionForever(santaAnimation))
        addChild(santa)
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([SKAction.runBlock(spawnEnemy),
                SKAction.waitForDuration(2.0)])))
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([SKAction.runBlock(spawnPresent),
                SKAction.waitForDuration(1.0)])))
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = UIColor.yellowColor()
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.position = CGPoint(x: 2000, y: 1250)
        addChild(scoreLabel)
        
        santaLivies = SKLabelNode(fontNamed: "Chalkduster")
        santaLivies.text = "Life: 5"
        santaLivies.fontSize = 50
        santaLivies.fontColor = UIColor.yellowColor()
        santaLivies.horizontalAlignmentMode = .Left
        santaLivies.position = CGPoint(x: 80, y: 1250)
        addChild(santaLivies)
        
        debugDrawPlayableArea()
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        if let lastTouch = lastTouchLocation {
            let diff = lastTouch - santa.position
            if (diff.length() <= santaMovePointsPerSec * CGFloat(dt)) {
                santa.position = lastTouchLocation!
                velocity = CGPointZero
                stopSantaAnimation()
            } else {
                moveSprite(santa, velocity: velocity)
                rotateSprite(santa, direction: velocity, rotateRadiansPerSec: santaRotateRadiansPerSec)
            }
        }
        
        boundsCheckSanta()
        moveTrain()
        
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
    
    func moveSantaToward(location: CGPoint) {
        startSantaAnimation()
        let offset = location - santa.position
        let direction = offset.normalized()
        velocity = direction * santaMovePointsPerSec
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        lastTouchLocation = touchLocation
        moveSantaToward(touchLocation)
    }
    
    override func touchesBegan(touches: Set<UITouch>,
        withEvent event: UIEvent?) {
            if let touch = touches.first {
                let touchLocation = touch.locationInNode(self)
                sceneTouched(touchLocation)
            }
            super.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>,
        withEvent event: UIEvent?) {
            if let touch = touches.first {
                let touchLocation = touch.locationInNode(self)
                sceneTouched(touchLocation)
            }
            super.touchesMoved(touches, withEvent: event)
            
    }
    
    func boundsCheckSanta() {
        let bottomLeft = CGPoint(x: 0,
            y: CGRectGetMinY(playableRect))
        let topRight = CGPoint(x: size.width,
            y: CGRectGetMaxY(playableRect))
        
        if santa.position.x <= bottomLeft.x {
            santa.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if santa.position.x >= topRight.x {
            santa.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if santa.position.y <= bottomLeft.y {
            santa.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if santa.position.y >= topRight.y {
            santa.position.y = topRight.y
            velocity.y = -velocity.y
        } 
    }
    
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        let shortest = shortestAngleBetween(sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        sprite.zRotation += shortest.sign() * amountToRotate
    }
    
    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "enemy"
        enemy.position = CGPoint(
            x: size.width + enemy.size.width/2,
            y: CGFloat.random(
                min: CGRectGetMinY(playableRect) + enemy.size.height/2,
                max: CGRectGetMaxY(playableRect) - enemy.size.height/2))
        addChild(enemy)
        
        let actionMove =
        SKAction.moveToX(-enemy.size.width/2, duration: 2.0)
        let actionRemove = SKAction.removeFromParent()
        enemy.runAction(SKAction.sequence([actionMove, actionRemove]))
        
    }


    func startSantaAnimation() {
        if santa.actionForKey("animation") == nil {
            santa.runAction(
                SKAction.repeatActionForever(santaAnimation),
                withKey: "animation")
        }
    }
    
    func stopSantaAnimation() {
        santa.removeActionForKey("animation")
    }

    func spawnPresent() {
        
        let present = SKSpriteNode(imageNamed: "present")
        present.name = "present"
        present.position = CGPoint(
            x: CGFloat.random(min: CGRectGetMinX(playableRect),
                max: CGRectGetMaxX(playableRect)),
            y: CGFloat.random(min: CGRectGetMinY(playableRect),
                max: CGRectGetMaxY(playableRect)))
        present.setScale(0)
        addChild(present)
        
        let appear = SKAction.scaleTo(1.0, duration: 0.5)
        
        present.zRotation = -π / 16.0
        let leftWiggle = SKAction.rotateByAngle(π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversedAction()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        let scaleUp = SKAction.scaleBy(1.2, duration: 0.25)
        let scaleDown = scaleUp.reversedAction()
        let fullScale = SKAction.sequence(
            [scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeatAction(group, count: 10)
        
        let disappear = SKAction.scaleTo(0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, groupWait, disappear, removeFromParent]
        present.runAction(SKAction.sequence(actions))
    }
        
    func santaHitPresent(present: SKSpriteNode) {
        runAction(presentCollisionSound)
        
        present.name = "train"
        present.removeAllActions()
        present.setScale(1.0)
        present.zRotation = 0
        
        let turnGreen = SKAction.colorizeWithColor(SKColor.greenColor(), colorBlendFactor: 1.0, duration: 0.2)
        present.runAction(turnGreen)
        ++score
    }
        
    func santaHitEnemy(enemy: SKSpriteNode) {
        enemy.removeFromParent()
        runAction(enemyCollisionSound)
        
        invincible = true
        
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customActionWithDuration(duration) { node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime) % slice
            node.hidden = remainder > slice / 2
        }
        let setHidden = SKAction.runBlock() {
            self.santa.hidden = false
            self.invincible = false
        }
        santa.runAction(SKAction.sequence([blinkAction, setHidden]))
        --life
        
    }
        
    func checkCollisions() {
        var hitPresents: [SKSpriteNode] = []
        enumerateChildNodesWithName("present") { node, _ in
            let present = node as! SKSpriteNode
            if CGRectIntersectsRect(present.frame, self.santa.frame) {
                hitPresents.append(present)
            }
        }
        for present in hitPresents {
            santaHitPresent(present)
        }
        
        if invincible {
            return
        }
        
        var hitEnemies: [SKSpriteNode] = []
        enumerateChildNodesWithName("enemy") { node, _ in
            let enemy = node as! SKSpriteNode
            if CGRectIntersectsRect(
                CGRectInset(node.frame, 20, 20), self.santa.frame) {
                    hitEnemies.append(enemy)
            }
        }
        for enemy in hitEnemies {
            santaHitEnemy(enemy)
            --score
            
        }
    }
        
    override func didEvaluateActions()  {
        checkCollisions()
    }
    
    func moveTrain() {
        
        var targetPosition = santa.position
        
        enumerateChildNodesWithName("train") { node, stop in
            if !node.hasActions() {
                
                let actionDuration = 0.3
                let offset = targetPosition - node.position
                let direction = offset.normalized()
                let amountToMovePerSec = direction * self.presentMovePointsPerSec
                let amountToMove = amountToMovePerSec * CGFloat(actionDuration)
                let moveAction = SKAction.moveByX(amountToMove.x, y: amountToMove.y, duration: actionDuration)
                node.runAction(moveAction)
            }
            targetPosition = node.position
            
        }
        
    }
    
}
