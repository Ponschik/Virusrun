//
//  Explosion.swift
//  Virusrun
//
//  Created by Sebastian Klotz on 21.06.15.
//  Copyright (c) 2015 Olga Koschel. All rights reserved.
//

import Foundation
import SpriteKit

class Explosion : SKNode {
    
    var numOfParticles : Int
    var particleTxtr : SKTexture
    var radius : CGFloat
    var origNode : SKSpriteNode
    
    var particles : NSMutableArray
    
    
    init(particleTexture partTxtr: SKTexture, numberOfParticles numPart: Int, radius rad: CGFloat, explodingNode orig: SKSpriteNode) {
        
        particleTxtr = partTxtr
        numOfParticles = numPart
        radius = rad
        origNode = orig
        
        particles = NSMutableArray()
        
//        var origRadius = orig.size.width
        
        super.init()
        
        for num in 0..<numPart {
            
            var particle = SKSpriteNode(imageNamed: "floatingBall.png")
            particle.color = GameColors.navy//UIColor(red:0.996,  green:0.835,  blue:0.827, alpha:1)//UIColor.blackColor()
            
            var randBlend = CGFloat.random(min: 0.8, max: 1)
            
            particle.colorBlendFactor = 1
//            particle.size = orig.size
            
            particle.physicsBody = SKPhysicsBody(circleOfRadius:particle.size.width/4)
            particle.physicsBody?.collisionBitMask = CollisionType.BobHull.rawValue | CollisionType.Floater.rawValue | CollisionType.Attacker.rawValue | CollisionType.Infusion.rawValue
            particle.physicsBody?.categoryBitMask = CollisionType.Infusion.rawValue
            particle.physicsBody?.contactTestBitMask = CollisionType.BobHull.rawValue
            particle.physicsBody?.affectedByGravity = false
            particle.physicsBody?.fieldBitMask = 0// FieldType.BobGravity.rawValue
            particle.physicsBody?.friction = 1
            
            
            var randScale = CGFloat.random(min: 0.3, max: 0.8)
            particle.xScale = randScale
            particle.yScale = randScale
            
            
            
            var randX: CGFloat
            var randY: CGFloat
            
            // Suche neuen Zielpunkt wenn nicht innerhalb des Radius des Originals
            do {
                randX = CGFloat.random(min: -rad, max: rad)
                randY = CGFloat.random(min: -rad, max: rad)
                
            } while ((randX*randX) + (randY*randY) >= rad*rad)
            
            particle.position = CGPointMake(orig.position.x + randX, orig.position.y + randY)
            
//            particles.addObject(particle)
            
            orig.parent?.addChild(particle)
            
            var randDuration = NSTimeInterval(CGFloat.random(min: 0.5, max: 1))
            
            var fadeOut = SKAction.scaleTo(0, duration: randDuration)
            
            var completion = SKAction.runBlock { () -> Void in
                particle.removeFromParent()
                self.particles.removeObject(particle)
            }
            
            var transfuseAction = SKAction.sequence([fadeOut, completion])
            
            particle.userData = NSMutableDictionary()
            
            particle.userData?.setObject(transfuseAction, forKey: "transfuseAction")
            
            // ATTACK ACTION ////////////////////////////////////////////////////////////////
            
            var attackWait = CGFloat.random(min: 0.3, max: 0.6)
            var waitForAttack = SKAction.waitForDuration(NSTimeInterval(attackWait))
            var attackBob = SKAction.runBlock { () -> Void in
                particle.physicsBody?.fieldBitMask = FieldType.BobGravity.rawValue
            }
            particle.runAction(SKAction.sequence([waitForAttack, attackBob]), withKey: "attack")
            
            ////////////////////////////////////////////////////////////////////////////////
            
            
            // DECAY ACTION ////////////////////////////////////////////////////////////////
            
            var randWait = CGFloat.random(min: 0.8, max: 1.5)
            var wait = SKAction.waitForDuration(NSTimeInterval(randWait))
            
            var decay = SKAction.scaleTo(0, duration: 0.6)
            
            particle.runAction(SKAction.sequence([wait, decay, completion]), withKey: "decay")
            
            ////////////////////////////////////////////////////////////////////////////////
            
//            particle.runAction(fadeOut, completion: { () -> Void in
//                particle.removeFromParent()
//                self.particles.removeObject(particle)
//            })
        }
    }
    
//    func bobContactByParticle(particle partic: SKSpriteNode) {
//        
//        if(partic.actionForKey("transfuse") == nil) {
//            var randDuration = NSTimeInterval(CGFloat.random(min: 2, max: 3))
//            var fadeOut = SKAction.scaleTo(partic.xScale, duration: randDuration)
//            var completion = SKAction.runBlock { () -> Void in
//                partic.removeFromParent()
//                self.particles.removeObject(partic)
//            }
//            
//            partic.runAction(SKAction.sequence([fadeOut, completion]), withKey:"transfuse")
//        }
//        
//        
//    }
    
//    override init() {
//        super.init()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
