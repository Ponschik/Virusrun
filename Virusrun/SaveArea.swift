//
//  SaveArea.swift
//  Virusrun
//
//  Created by Olga Koschel on 07.06.15.
//  Copyright (c) 2015 Olga Koschel. All rights reserved.
//

import Foundation
import SpriteKit

class SaveArea: SKNode {
    
    //    let babbelsLinearDamp:CGFloat = 1
//    let bobColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    //    let bobSize = CGSize(width: 187, height: 187)
//    let bacTexture = SKTexture(imageNamed: "circleBac.png")
    
    //(x - center_x)^2 + (y - center_y)^2 < radius^2
    let forceField: SKFieldNode = SKFieldNode.radialGravityField()
    
    let radius : CGFloat = 125
    
    var gravityOnOff : SKAction!
    
    
    let circle1 = SKSpriteNode(imageNamed: "whiteBall.png")
    let circle2 = SKNode()
    let circle3 = SKNode()
    let circle4 = SKNode()
    
    var minMoveDist : CGFloat = 100
    
    let moveSpeed : CGFloat = 0.02
    
    
    override init() {
        super.init()
        
        
       // let expand : SKAction = SKAction.resizeByWidth(100, height: 100, duration: 4)
        let expand = SKAction.scaleBy(0.8, duration: 6)
        expand.timingMode = SKActionTimingMode.EaseInEaseOut
        let breathe : SKAction  = SKAction.sequence([expand, expand.reversedAction()])
        
//        runAction(SKAction.repeatActionForever(breathe))
        generateMoveAction()
        
        
        forceField.enabled = true
        forceField.strength = 0.7
        forceField.categoryBitMask = FieldType.SaveAreaGravity.rawValue
        addChild(forceField)
        
        
        circle1.size = CGSizeMake(radius*2.1, radius*2.1)
        circle1.blendMode = SKBlendMode.Screen
//        circle1.colorBlendFactor = 1
        circle1.alpha = 0.15
//        circle1.blendMode = SKBlendMode(rawValue: 4)!
        circle1.zPosition = 0
        circle1.color = UIColor(red: 0.2, green: 0.7, blue: 0.7, alpha: 0.4)
        circle1.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        circle1.physicsBody?.categoryBitMask = CollisionType.SaveArea.rawValue
        circle1.physicsBody?.collisionBitMask = CollisionType.Floater.rawValue
        circle1.physicsBody?.allowsRotation = false
        circle1.physicsBody?.affectedByGravity = false
        circle1.physicsBody?.dynamic = false
        
//        circle2.position = CGPointMake(120, 100)
//        circle2.physicsBody = SKPhysicsBody(circleOfRadius: radius*0.6)
//        circle2.physicsBody?.collisionBitMask = CollisionType.Floater.rawValue
//        circle2.physicsBody?.allowsRotation = false
//        circle2.physicsBody?.affectedByGravity = false
//        circle2.physicsBody?.dynamic = false
//        
//        circle3.position = CGPointMake(-120, 100)
//        circle3.physicsBody = SKPhysicsBody(circleOfRadius: radius*0.6)
//        circle3.physicsBody?.collisionBitMask = CollisionType.Floater.rawValue
//        circle3.physicsBody?.allowsRotation = false
//        circle3.physicsBody?.affectedByGravity = false
//        circle3.physicsBody?.dynamic = false
//        
//        circle4.position = CGPointMake(0, -120)
//        circle4.physicsBody = SKPhysicsBody(circleOfRadius: radius*0.5)
//        circle4.physicsBody?.collisionBitMask = CollisionType.Floater.rawValue
//        circle4.physicsBody?.allowsRotation = false
//        circle4.physicsBody?.affectedByGravity = false
//        circle4.physicsBody?.dynamic = false
        
        addChild(circle1)
//        addChild(circle2)
//        addChild(circle3)
//        addChild(circle4)

        var gravOff = SKAction.runBlock { () -> Void in
            self.forceField.strength = 0
        }
        var wait = SKAction.waitForDuration(0.9)
        var gravOn = SKAction.runBlock { () -> Void in
            self.forceField.strength = 1
        }
        gravityOnOff = SKAction.sequence([gravOff, wait,gravOn]);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bobHitFloater() {
        if(actionForKey("gravOffOn") == nil) {
            println("GRAV OFF ON")
            runAction(gravityOnOff, withKey:"grafOffOn")
        }
    }
    
    
    
    func generateMoveAction(){
        // (x - center_x)^2 + (y - center_y)^2 < radius^2
        var randX: CGFloat
        var randY: CGFloat
        var dist: CGFloat
        
        let radius: CGFloat = 384 - self.radius
        
        // Suche neuen Zielpunkt wenn nicht innerhalb des Kreises und Distanz < 500
        do {
            randX = CGFloat.random(min: -radius, max: radius)
            randY = CGFloat.random(min: -radius, max: radius)
            let dx = self.position.x - randX
            let dy = self.position.y - randY
            dist = sqrt(dx*dx + dy*dy)
            
//            println("dist: \(dist)")
            
        } while (((randX*randX) + (randY*randY) >= radius*radius) || (dist <= minMoveDist))
        
        let wait = SKAction.waitForDuration(0)
        
        let moveDuration = NSTimeInterval(moveSpeed*dist)
        
        let moveTo = SKAction.moveTo(CGPointMake(randX, randY), duration:moveDuration)
        moveTo.timingMode = SKActionTimingMode.EaseInEaseOut
        
        let completion = SKAction.runBlock { () -> Void in
            self.minMoveDist = 250
            self.generateMoveAction()
        }
        
        runAction(SKAction.sequence([wait, moveTo, completion]), withKey:"moveAction");
    }
    
    func waitAndStartMoveAction() {
        var wait = SKAction.waitForDuration(2)
        runAction(wait, completion: { () -> Void in
            self.generateMoveAction()
        })
    }
    
    func changeToAttackState() {
        moveBackToCenter()
        
    }
    
    
    func moveBackToCenter() {
        removeActionForKey("moveAction")
        
        let dx = self.position.x - position.x
        let dy = self.position.y - position.y
        let dist = sqrt(dx*dx + dy*dy)
        
        let moveDuration = NSTimeInterval(moveSpeed*dist)

        
        runAction(SKAction.moveTo(CGPointZero, duration: 0), completion: { () -> Void in
//            self.removeAllActions()
            self.position = CGPointZero
        })
    }
    
    func startBreedToTransformWay() {
        
    }
    
    
//    func generateJumpAction() {
//        var randX: CGFloat
//        var randY: CGFloat
//        
//        let radius: CGFloat = 384 - self.radius
//        
//        do {
//            randX = CGFloat.random(min: -radius, max: radius)
//            randY = CGFloat.random(min: -radius, max: radius)
//        } while (randX*randX) + (randY*randY) >= radius*radius
//        
//        let moveTo = SKAction.moveTo(CGPointMake(randX, randY), duration: 0.5)
//        moveTo.timingMode = SKActionTimingMode.EaseInEaseOut
//        runAction(moveTo, completion: { () -> Void in
//            self.generateMoveAction()
//        })
//
//    }
    
    
}