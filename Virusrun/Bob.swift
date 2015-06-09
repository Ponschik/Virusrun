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
    
    let babbelsLinearDamp:CGFloat = 1
    let bobColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    let bobSize = CGSize(width: 187, height: 187)
    let bobTexture = SKTexture(imageNamed: "babbels374.png")
    
    
//    let vortexField : SKFieldNode = SKFieldNode.vortexField()

    init() {
        super.init(texture: bobTexture, color: bobColor, size: bobSize)
        
        
        
        
//        vortexField.enabled = true
//        vortexField.strength = 0.05
//        vortexField.categoryBitMask = FieldType.bobGravity.rawValue
//        addChild(vortexField)
        
        zPosition = 20
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.categoryBitMask = CollisionType.Bob.rawValue
        physicsBody?.contactTestBitMask = CollisionType.Floater.rawValue
        physicsBody?.collisionBitMask = CollisionType.Floater.rawValue
        physicsBody?.friction = 0.9
        physicsBody?.allowsRotation = false
        physicsBody?.linearDamping = babbelsLinearDamp
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}