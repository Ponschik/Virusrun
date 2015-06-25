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
    
    let bacTexture = SKTexture(imageNamed: "floatingMine9.png")
    let bacTexture2 = SKTexture(imageNamed: "floatingMine7.png")
    
//    let bacTexture = SKTexture(imageNamed: "equalTriangleWhite.png")
    
    let cherryRed = UIColor(red: 0.843, green: 0.188, blue: 0.254, alpha: 1)
    let turksie = UIColor(red:0.125, green:0.741, blue:0.616, alpha: 1)
    let navy = UIColor(red:0.184, green:0.200, blue:0.322, alpha: 1)
    let clear = UIColor.clearColor()
    
    
    
    var origScale : CGFloat!
    
    var hitAction : SKAction!
    var recolorAction :SKAction!
    
    var scaleAction : SKAction!
    var rescaleAction : SKAction!
    
    var removeAction : SKAction!
    
    init() {
        
        let startColor = UIColor(red:0.686, green:0.863, blue:0.682, alpha: 1)//UIColor.blackColor()//turksie
        
        let randTxtr = CGFloat.random()
        
        var usedTexture : SKTexture
        
        if (randTxtr > 0) {
            usedTexture = bacTexture
        } else {
            usedTexture = bacTexture2
        }
        
        super.init(texture: usedTexture, color: startColor, size: usedTexture.size())
        
        let rand = CGFloat.random(min: 0.5, max: 0.7)
        colorBlendFactor = 0.8
//        alpha = 0.6
        
        let randRotation = CGFloat.random(min: CGFloat(-M_PI), max: CGFloat(M_PI))
        zRotation = randRotation
        
        zPosition = 10
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2 + 6)
        physicsBody?.categoryBitMask = CollisionType.Floater.rawValue
        physicsBody?.collisionBitMask = CollisionType.BobHull.rawValue | CollisionType.Floater.rawValue | CollisionType.SaveArea.rawValue | CollisionType.Attacker.rawValue
//        physicsBody?.friction = 0.9
        physicsBody?.allowsRotation = false
//        physicsBody?.linearDamping = babbelsLinearDamp
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        physicsBody?.fieldBitMask = FieldType.SaveAreaGravity.rawValue
        
        origScale = CGFloat.random(min: 0.5, max: 1)
        
        xScale = origScale
        yScale = origScale
        
        println("Floater size: \(size.width)")
        
        hitAction = SKAction.colorizeWithColor(SKColor.blackColor(), colorBlendFactor: 1, duration: 0.08) // 0.12
        recolorAction = SKAction.colorizeWithColor(startColor, colorBlendFactor: colorBlendFactor, duration: 0.3)
        
        scaleAction = SKAction.scaleTo(2, duration: 0.1)
        rescaleAction = SKAction.scaleTo(origScale, duration: 0.5)
        
        var randTime = CGFloat.random(min: 5, max: 10)
        
        var scale = SKAction.scaleBy(0.8, duration: Double(randTime))
        scale.timingMode = SKActionTimingMode.EaseInEaseOut
        var rescale = SKAction.scaleTo(origScale, duration: Double(randTime))
        rescale.timingMode = SKActionTimingMode.EaseInEaseOut
        runAction(SKAction.repeatActionForever(SKAction.sequence([scale, rescale])))
        
        removeAction = SKAction.runBlock({ () -> Void in
            if (self.scene != nil) {
                var gameScene = self.scene as! GameScene
                gameScene.shakeCamera(0.5)
            }
            self.explode()
            self.removeFromParent()
        })

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func bobContact(bob:Bob) {
//        removeActionForKey("endContact")
//        var bobHit = SKAction.runBlock({ () -> Void in
//            bob.floaterHit()
//        })
//        runAction(SKAction.sequence([hitAction, bobHit]), withKey:"contact")
//        
////        runAction(scaleAction, withKey: "contact")
//    }
    
    
    func explode() {
//        var emitterNode = SKEmitterNode(fileNamed: "FloaterExplosion.sks")
//        emitterNode.position = position
//        emitterNode.zPosition = 20
//        emitterNode.advanceSimulationTime(0.1)
////        emitterNode.fieldBitMask = FieldType.BobGravity.rawValue
//        parent?.addChild(emitterNode)
//        self.runAction(SKAction.waitForDuration(2), completion: { () -> Void in
//            emitterNode.removeFromParent()
//        })
        
        var explosion = Explosion(particleTexture: texture!, numberOfParticles: 10, radius: texture!.size().width, explodingNode: self)
    }
    
    
    func bobHullContact(bobHull:BobHull) {
        removeActionForKey("endContact")
        if (bobHull.actionForKey("invincible") == nil) {
            var bobHit = SKAction.runBlock({ () -> Void in
                bobHull.floaterHit(self.position)
            })
            
//            var remove = SKAction.runBlock({ () -> Void in
//                if (self.scene != nil) {
//                    var gameScene = self.scene as! GameScene
//                    gameScene.shakeCamera(0.5)
//                }
////                self.explode()
//                self.removeFromParent()
//            })
            
            var explodeAction = SKAction.sequence([SKAction.group([bobHit, scaleAction]), removeAction])
            
            var completion = SKAction.runBlock({ () -> Void in
                self.runAction(explodeAction, withKey: "explodeAction")
            })
            
            runAction(SKAction.sequence([hitAction, completion]), withKey: "contact")
            
//            runAction(SKAction.sequence([hitAction, SKAction.group([bobHit, scaleAction]), removeAction]), withKey:"contact")
            

        }
    }
    
    func bobHullContactDirectHit(bobHull: BobHull) {
        removeActionForKey("endContact")
//        if (bobHull.actionForKey("invincible") == nil) {
            var bobHit = SKAction.runBlock({ () -> Void in
                bobHull.floaterHit(self.position)
            })
            
            self.color = UIColor.blackColor()
            self.colorBlendFactor = 1
            
            runAction(SKAction.sequence([SKAction.group([bobHit, scaleAction]), removeAction]), withKey:"contact2")
            
            
//        }
    }
    
    func bobEndContact() {
        removeActionForKey("contact")
        runAction(recolorAction, withKey: "endContact")
        runAction(rescaleAction)
    }
}