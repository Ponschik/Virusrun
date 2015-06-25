//
//  BobHull.swift
//  Virusrun
//
//  Created by Sebastian Klotz on 14.06.15.
//  Copyright (c) 2015 Olga Koschel. All rights reserved.
//

import Foundation
import SpriteKit

class BobHull: SKNode {
    var hullTexture = SKTexture(imageNamed: "bobFlat2.png")
    var hullTopTexture = SKTexture(imageNamed: "bobFlat4.png")
    let hullColor = UIColor(red:0.698,  green:0.878,  blue:0.592, alpha:1)//GameColors.turksieColor//UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    let hullTopColor = UIColor(red:0,  green:0.557,  blue:0.455, alpha:1)
    let hullSize = CGSize(width: 145, height: 145)//187
//    let hullTopSize = CGSize
    
    var hullSprite: SKSpriteNode
    var hullTopSprite : SKSpriteNode
    
    let origScale : CGFloat! = 1;
    
    let attackerForceField : SKFieldNode = SKFieldNode.radialGravityField()
    
    var subtractAction : SKAction!
    var addAction : SKAction!
    
    var makeContactFace : SKAction!
    var makeNormalFace : SKAction!
    
    let protector = Protector()
    
    var scaleAction, underscaleAction, rescaleAction : SKAction!
    
    var numOfContacts = 0
    
    var bobs : NSMutableArray
    
    var origAlpha : CGFloat
    
    var bobShine : SKSpriteNode
    
    
    override init () {
        
        hullSprite = SKSpriteNode(texture: hullTexture, color: hullColor, size: hullTexture.size())
        hullTopSprite = SKSpriteNode(texture: hullTopTexture, color: hullTopColor, size: hullTopTexture.size())
        bobs = NSMutableArray()
        
        bobShine = SKSpriteNode(imageNamed: "bobFlat1.png")
        bobShine.zPosition = 22
        bobShine.xScale = 0.95
        bobShine.yScale = 0.95
        
        origAlpha = 0.7
        
//        super.init(texture: hullTexture, color: hullColor, size: hullSize)
        super.init()
        
        addChild(hullTopSprite)
        addChild(hullSprite)
        addChild(bobShine)
        
        
        hullSprite.colorBlendFactor = 0
        hullSprite.zPosition = 21
        hullSprite.alpha = 0.6
        
        hullTopSprite.colorBlendFactor = 0
        hullTopSprite.zPosition = 19
        
        
        alpha = origAlpha
        
        var circlePath = CGPathCreateMutable()
//        CGPathAddArc(circlePath, nil, 0, 0, 100, 0, M_PI * 2, true)
        CGPathAddArc(circlePath, nil, 0, 0, hullSize.width/2, 0, CGFloat(M_PI*2), true)
        
        hullSprite.physicsBody = SKPhysicsBody(circleOfRadius: (hullSprite.size.width/2)-0)
        hullSprite.physicsBody?.categoryBitMask = CollisionType.BobHull.rawValue
        hullSprite.physicsBody?.contactTestBitMask = CollisionType.Floater.rawValue | CollisionType.Attacker.rawValue
        hullSprite.physicsBody?.collisionBitMask = CollisionType.Floater.rawValue
        hullSprite.physicsBody?.dynamic = false
        hullSprite.physicsBody?.friction = 1
        
        attackerForceField.enabled = true
        attackerForceField.strength = 10
        attackerForceField.categoryBitMask = FieldType.BobGravity.rawValue
        
        addChild(attackerForceField)
        
//        addChild(protector)
        
        subtractAction = SKAction.runBlock({ () -> Void in
            self.hullSprite.blendMode = SKBlendMode.Subtract
        })
        
        addAction = SKAction.runBlock({ () -> Void in
            self.hullSprite.blendMode = SKBlendMode.Alpha
        })
        
        makeContactFace = SKAction.runBlock({ () -> Void in
//            self.texture = self.bobContactTexture
        })
        
        makeNormalFace = SKAction.runBlock({ () -> Void in
//            self.texture = self.bobTexture
        })
        
        scaleAction = SKAction.scaleTo(1.8, duration: 0.03)
        scaleAction.timingMode = SKActionTimingMode.EaseOut
        
        underscaleAction = SKAction.scaleTo(origScale-0.2, duration: 0.3)
        underscaleAction.timingMode = SKActionTimingMode.EaseInEaseOut

        rescaleAction = SKAction.scaleTo(origScale, duration: 0.3)
        rescaleAction.timingMode = SKActionTimingMode.EaseInEaseOut
    }
    
    func shakeHull(duration:Float) {
        let amplitudeX:Float = 10;
        let amplitudeY:Float = 6;
        let numberOfShakes = duration / 0.04;
        var actionsArray : [SKAction] = [];
        for index in 1...Int(numberOfShakes) {
            // build a new random shake and add it to the list
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
            let shakeAction = SKAction.moveByX(CGFloat(moveX), y: CGFloat(moveY), duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.EaseOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversedAction());
        }
        
        let actionSeq = SKAction.sequence(actionsArray);
        runAction(actionSeq, withKey:"shake");
    }
    
    func floaterHit(pos:CGPoint) {
        numOfContacts++
        if(actionForKey("hitAction") == nil){
//            var gameScene = scene as! GameScene
//            gameScene.shakeCamera(0.6)
            
            // Remove 1 Bob when damaged
            if (bobs.count > 0) {
                var killedBob = bobs.lastObject as! Bob
                killedBob.explode()
                bobs.removeLastObject()
            }
            
            for bob in bobs {
                var aBob = bob as! Bob
                aBob.floaterHit()
            }
            
            
            hullSprite.removeActionForKey("endContactAction")
            var wait = SKAction.waitForDuration(0.0)
            var cooldown = SKAction.waitForDuration(0.5)
            
            var fadeAlpha = SKAction.fadeAlphaTo(origAlpha, duration: 0.2)
            var fadeBack = SKAction.fadeAlphaTo(origAlpha, duration: 0.3)
            var blinkAlpha = SKAction.repeatAction(SKAction.sequence([fadeAlpha, fadeBack]), count: 6)
            
            shakeHull(1)
            
            runAction(SKAction.sequence([makeContactFace, scaleAction, wait, underscaleAction, rescaleAction, cooldown, makeNormalFace]), withKey:"hitAction")
            
            var waitForInvincible = SKAction.waitForDuration(0.5)
            var startInvincibleAction = SKAction.runBlock({ () -> Void in
                self.runAction(blinkAlpha, withKey:"invincible")
            })
            
            runAction(SKAction.sequence([waitForInvincible, startInvincibleAction]), withKey: "waitForInvincible")
            
//            runAction(blinkAlpha, withKey:"invincible")
            
        }
    }
    
    func floaterEndContact() {
        numOfContacts--
        //        if(numOfContacts == 0 && actionForKey("endContactAction") == nil) {
        //            var wait = SKAction.waitForDuration(0.1)
        //            var cooldown = SKAction.waitForDuration(1)
        //            runAction(SKAction.sequence([wait, makeNormalFace, rescaleAction, cooldown]), withKey:"endContactAction")
        //        }
        
    }
    
    func transfuse() {
        
//        if (hullSprite.actionForKey("colorize") == nil) {
//            
//            var colorBack = SKAction.colorizeWithColorBlendFactor(0, duration: 1)
////            hullSprite.runAction(colorBack, withKey: "colorBack")
//            var wait = SKAction.waitForDuration(2)
//            
//            var colorize = SKAction.colorizeWithColorBlendFactor(1, duration: 1)
//            hullSprite.runAction(SKAction.sequence([colorize, wait, colorBack]), withKey: "colorize")
//        }
        
        
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}