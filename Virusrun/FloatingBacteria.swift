//
//  FloatingBacteria.swift
//  
//
//  Created by Olga Koschel on 07.06.15.
//
//

import Foundation
import SpriteKit

class FloatingBacteria: SKSpriteNode {
    
    let bacTexture = SKTexture(imageNamed: "floatingBall.png")
    
    let cherryRed = UIColor(red: 0.843, green: 0.188, blue: 0.254, alpha: 1)
    let turksie = UIColor(red: 0.01, green: 0.674, blue: 0.76, alpha: 1)
    
    init() {
        super.init(texture: bacTexture, color: cherryRed, size: bacTexture.size())
        
        let rand = CGFloat.random(min: 0.5, max: 0.9)
        colorBlendFactor = rand
        
        let randRotation = CGFloat.random(min: CGFloat(-M_PI), max: CGFloat(M_PI))
        
        zRotation = randRotation
        
        zPosition = 10
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2 + 6)
        physicsBody?.categoryBitMask = CollisionType.Floater.rawValue
        physicsBody?.collisionBitMask = CollisionType.Bob.rawValue | CollisionType.Floater.rawValue
//        physicsBody?.friction = 0.9
        physicsBody?.allowsRotation = false
//        physicsBody?.linearDamping = babbelsLinearDamp
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        physicsBody?.fieldBitMask = FieldType.bobGravity.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}