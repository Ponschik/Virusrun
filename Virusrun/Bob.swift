//
//  Bob.swift
//  Virusrun
//
//  Created by Olga Koschel on 24.05.15.
//  Copyright (c) 2015 Olga Koschel. All rights reserved.
//

import Foundation
import SpriteKit

class Bob: SKSpriteNode {
    
    let babbelsLinearDamp:CGFloat = 0
    let bobColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    let bobSize = CGSize(width: 60, height: 60)//75//187
    let bobTexture = SKTexture(imageNamed: "babbels374.png")
    let bobContactTexture = SKTexture(imageNamed: "babbelsPressed374.png")
    let protector = Protector()
    
    let origScale : CGFloat! = 1;
    
    var subtractAction : SKAction!
    var addAction : SKAction!
    
    var makeContactFace : SKAction!
    var makeNormalFace : SKAction!
    
    var scaleAction, rescaleAction : SKAction!
    
    var numOfContacts = 0
    
//    let vortexField : SKFieldNode = SKFieldNode.vortexField()

    init() {
        super.init(texture: bobTexture, color: bobColor, size: bobSize)
        
        
//        vortexField.enabled = true
//        vortexField.strength = 0.05
//        vortexField.categoryBitMask = FieldType.BobGravity.rawValue
//        addChild(vortexField)
        
        zPosition = 20
        physicsBody = SKPhysicsBody(circleOfRadius: (size.width/2))
        physicsBody?.categoryBitMask = CollisionType.Bob.rawValue
        physicsBody?.contactTestBitMask = 0//CollisionType.BobHull.rawValue
        physicsBody?.collisionBitMask = CollisionType.Bob.rawValue | CollisionType.BobPuff.rawValue
        physicsBody?.fieldBitMask = 16
        physicsBody?.friction = 0.1
        physicsBody?.allowsRotation = true
        physicsBody?.linearDamping = babbelsLinearDamp
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        
        
//        addChild(protector)
        
        subtractAction = SKAction.runBlock({ () -> Void in
            self.blendMode = SKBlendMode.Subtract
        })
        
        addAction = SKAction.runBlock({ () -> Void in
            self.blendMode = SKBlendMode.Alpha
        })
        
        makeContactFace = SKAction.runBlock({ () -> Void in
            self.texture = self.bobContactTexture
        })
        
        makeNormalFace = SKAction.runBlock({ () -> Void in
            self.texture = self.bobTexture
        })
        
        scaleAction = SKAction.scaleTo(1.5, duration: 0.06)
        rescaleAction = SKAction.scaleTo(origScale, duration: 0.06)
    }

    func floaterHit() {
        numOfContacts++
        if(actionForKey("hitAction") == nil){
            removeActionForKey("endContactAction")
            var wait = SKAction.waitForDuration(0.07)
            var cooldown = SKAction.waitForDuration(0.5)
            
            runAction(SKAction.sequence([makeContactFace, scaleAction, wait, rescaleAction, cooldown, makeNormalFace]), withKey:"hitAction")
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
    
    func explode() {
        
        var explosionScale = SKAction.scaleTo(2, duration: 0.12)
        var colorBlack = SKAction.colorizeWithColor(UIColor.blackColor(), colorBlendFactor: 1, duration: 0.1)
        runAction(SKAction.group([explosionScale, colorBlack]), completion: { () -> Void in
            BobPuff(numberOfParticles: 15, radius: self.size.width/2, explodingNode: self)
            self.removeFromParent()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}