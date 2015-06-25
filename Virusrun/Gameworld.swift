//
//  Gameworld.swift
//  Virusrun
//
//  Created by Olga Koschel on 24.05.15.
//  Copyright (c) 2015 Olga Koschel. All rights reserved.
//

import Foundation
import SpriteKit

class Gameworld: SKNode {
    
    let background1 = SKNode()
    let background2 = SKNode()
    let background3 = SKNode()
    
    let rotateArea = SKNode()
    
    let playground = SKNode()
    let bob = Bob()
    let bobHull = BobHull()
    
    let saveArea = SaveArea()
    
    let floaters = NSMutableArray()
    
    var attacker = Virus()
    
    var gameplayActive : Bool = true
    
    override init() {
        
        super.init()
        
        addChild(background3)
        addChild(background2)
        addChild(background1)
        
        var bg1Layer = SKSpriteNode(color: GameColors.bgColor, size: CGSizeMake(1024, 1024))
//        var bg1Layer = SKSpriteNode(imageNamed: "background01.jpg");
        bg1Layer.alpha = 0.93
        bg1Layer.zPosition = -10
        background1.addChild(bg1Layer)
        
        var bg2Layer = SKSpriteNode(color: GameColors.bgColor, size: CGSizeMake(1024, 1024))
        bg2Layer.alpha = 0.2
        bg2Layer.zPosition = -20
        background2.addChild(bg2Layer)
        
        var bg3Layer = SKSpriteNode(color: GameColors.bgColor, size: CGSizeMake(1024, 1024))
        bg3Layer.alpha = 0.2
        bg3Layer.zPosition = -30
        background3.addChild(bg3Layer)

        
        background1.zPosition = -10
        background2.zPosition = -20
        background3.zPosition = -30
        
//        background1.alpha = 0.15
//        background2.alpha = 0.1
//        background3.alpha = 0.05
        
        addChild(rotateArea)
        
        rotateArea.addChild(playground)
        playground.addChild(bobHull)
//        playground.addChild(bob)
        playground.addChild(saveArea)
        
        
        createBobs()
//        var bobConstraint = SKConstraint.distance(SKRange(lowerLimit: 0, upperLimit: 40), toNode: bobHull)
//        bob.constraints = [bobConstraint]

        
        initAndAddEnemys()
        
        
//        playground.addChild(attacker)
        addFloater()
//        newAttacker()
        
        scene?.filter
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(currentTime: CFTimeInterval) {
//        println("AttackerZ: \(attacker.zRotation)")
//        moveAttacker()
        
        rotateArea.position = bobHull.position
        playground.position = CGPointMake(-bobHull.position.x, -bobHull.position.y)
        
        println("FloatersCount: \(floaters.count)")
        
        if (floaters.count == 0) {
            addFloater()
        }
        
        
    }
    
    func didFinishUpdate() {
//        moveAttacker()
//        bobShine.zRotation = bobHull.zRotation
    }
    
    func createBobs() {
        var bobConstraint = SKConstraint.distance(SKRange(lowerLimit: 0, upperLimit: 40), toNode: bobHull) // upperLimit:55
        for num in 1...2 {
            var newBob = Bob()
            newBob.position = CGPointMake(CGFloat(num*100), 0)
            newBob.constraints = [bobConstraint]
//            newBob.zRotation = CGFloat.random(min: 0, max: CGFloat(M_PI*2))
            playground.addChild(newBob)
            
            bobHull.bobs.addObject(newBob)
            
            println("Bob \(num)")
        }
    }
    
    func addFloater() {
        for var i = 0; i <= 100; i++ {
            
            var randX: CGFloat
            var randY: CGFloat
            
            let radius: CGFloat = 200
            
            // (x - center_x)^2 + (y - center_y)^2 < radius^2
            
            let addRadius : CGFloat = 600
            
            do {
                randX = CGFloat.random(min: -addRadius, max: addRadius)
                randY = CGFloat.random(min: -addRadius, max: addRadius)
            } while (randX*randX) + (randY*randY) < radius*radius
            
            let floater = FloatingBacteria()
            floater.position = CGPointMake(randX, randY)
            
            floaters.addObject(floater)
            
            playground.addChild(floater)
        }
    }
    
    func removeFloaters() {
        var floatersArray = floaters as NSArray
        for floater : FloatingBacteria in floatersArray as! [FloatingBacteria] {
            floater.removeFromParent()
        }
    }
    
    func rotateFloater(newRotation:CGFloat) {
        for floater in floaters {
            (floater as! FloatingBacteria).zRotation = newRotation
        }
    }
    
    func newAttacker() {
//        attacker.removeFromParent()
        
//        attacker = Virus()
        
        var randAngle = CGFloat.random(min: 0, max: CGFloat(M_PI*2))
        
        println(randAngle)
        
        var randX = 600 * cos(randAngle)
        var randY = 600 * sin(randAngle)
//        attacker.position = CGPointMake(randX, randY)
        
        attacker.runAction(SKAction.moveTo(CGPointMake(randX, randY), duration: 0))
        
//        println("newX:\(randX) newY:\(randY)");
        
//        var rotateToBob = SKConstraint.orientToNode(bobHull, offset: SKRange(lowerLimit: 0, upperLimit: 0))
//        attacker.constraints = [rotateToBob]
        
        
//        playground.addChild(attacker)
        
    }
    
    func moveAttacker() {
        
        var x = attacker.position.x - bobHull.position.x
        var y = bobHull.position.y - attacker.position.y
        var direction = atan2(x, y) + CGFloat(M_PI_2)
                
        var velX = 0.7 * cos(direction)
        var velY = 0.7 * sin(direction)
        
//        println("moveX:\(attacker.position.x) moveY:\(attacker.position.y)");
        
        attacker.position = CGPointMake(attacker.position.x + velX, attacker.position.y + velY)
        
    }
    
    func initAndAddEnemys() {
        
        
        // TODO: Cleanup
        let circleBac = SKTexture(imageNamed: "floatingBall.png")
        let greenBac = SKTexture(imageNamed: "floatingBall.png")
        let ballChainBac = SKTexture(imageNamed: "floatingBall.png")
        let pinkBac = SKTexture(imageNamed: "floatingBall.png")
        let enemysAmount = 200
        let gameWorldSizeMin : CGFloat = -500
        let gameWorldSizeMax : CGFloat = 500
        
        var bacillus:SKSpriteNode
        
        for var i = 0; i <= enemysAmount; i++ {
            
            let rand = CGFloat.random()
            var ground = SKNode()
            
            if rand < 0.25 {
                bacillus = SKSpriteNode(texture: circleBac)
                ground = background3
                
                bacillus.zPosition = -31
                var randScale = CGFloat.random(min: 0.05, max: 0.2)
                bacillus.xScale = randScale
                bacillus.yScale = randScale
                
            } else if rand < 0.5 {
                
                bacillus = SKSpriteNode(texture: greenBac)
                ground = background3
                
                
                bacillus.zPosition = -31
                
                var randScale = CGFloat.random(min: 0.05, max: 0.2)
                bacillus.xScale = randScale
                bacillus.yScale = randScale
                
            } else if rand < 0.75 {
                
                bacillus = SKSpriteNode(texture: ballChainBac)
                ground = background2
                
                bacillus.zPosition = -21
                
                var randScale = CGFloat.random(min: 0.2, max: 0.3)
                bacillus.xScale = randScale
                bacillus.yScale = randScale
                
            } else {
                
                bacillus = SKSpriteNode(texture: pinkBac)
                ground = background1
                
                bacillus.zPosition = -11
                
                var randScale = CGFloat.random(min: 0.4, max: 0.7)
                bacillus.xScale = randScale
                bacillus.yScale = randScale
                
            }
            
//            if bacillus.position.x <= bob.position.x {
//            bacillus.physicsBody = SKPhysicsBody(texture: bacillus.texture, size: bacillus.size)
//            bacillus.physicsBody?.allowsRotation = false
//            bacillus.physicsBody?.affectedByGravity = false
//            }
            ground.addChild(bacillus)
            
            bacillus.color = GameColors.turksieColor
            bacillus.colorBlendFactor = 0
            bacillus.alpha = 0.6
            
            
            
            let randX = CGFloat.random(min: gameWorldSizeMin, max: gameWorldSizeMax)
            let randY = CGFloat.random(min: gameWorldSizeMin, max: gameWorldSizeMax)
            
            bacillus.position = CGPointMake(randX, randY)
            bacillus.zRotation = CGFloat.random(min: 0, max: 6.3)
        }
        
    }
    
    func bobFarOut() -> Bool {
        let dx = bobHull.position.x - saveArea.position.x
        let dy = bobHull.position.y - saveArea.position.y
        let dist = sqrt(dx*dx + dy*dy)
        
//        println("bob far: \(dist)")
        
        if (dist > 120) {
            return true
        }
        return false
    }
    
}



















