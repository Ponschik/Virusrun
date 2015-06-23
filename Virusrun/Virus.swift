//
//  Virus.swift
//  Virusrun
//
//  Created by Sebastian Klotz on 15.06.15.
//  Copyright (c) 2015 Olga Koschel. All rights reserved.
//

import Foundation
import SpriteKit

class Virus: SKSpriteNode {
    
    let virusTxtr = SKTexture(imageNamed: "virus1.png")
    let radius : CGFloat = 50
    
    init() {
        super.init(texture: virusTxtr, color: SKColor.clearColor(), size: CGSizeMake(radius*2, radius*2))
        
        physicsBody = SKPhysicsBody(circleOfRadius: radius+22)
        physicsBody?.categoryBitMask = CollisionType.Attacker.rawValue
        physicsBody?.contactTestBitMask = CollisionType.BobHull.rawValue | CollisionType.Protector.rawValue
        physicsBody?.collisionBitMask = CollisionType.BobHull.rawValue | CollisionType.Floater.rawValue
        physicsBody?.fieldBitMask = 0//FieldType.BobGravity.rawValue
//        physicsBody?.friction = 0.1
//        physicsBody?.allowsRotation = true
//        physicsBody?.linearDamping = babbelsLinearDamp
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = false
        
        var rotate = SKAction.rotateByAngle(2*CGFloat(M_PI_2), duration: 2)
        runAction(SKAction.repeatActionForever(rotate))
        
        var scale = SKAction.scaleBy(1.2, duration: 0.6)
        scale.timingMode = SKActionTimingMode.EaseInEaseOut
        var rescale = SKAction.scaleTo(1, duration: 0.6)
        rescale.timingMode = SKActionTimingMode.EaseInEaseOut
        runAction(SKAction.repeatActionForever(SKAction.sequence([scale, rescale])))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}