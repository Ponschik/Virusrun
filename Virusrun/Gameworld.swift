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
    
    let playground = SKNode()
    let bob = Bob()
    
    let saveArea = SaveArea()
    
    override init() {
        
        super.init()
        
        addChild(background3)
        addChild(background2)
        addChild(background1)
        
        addChild(playground)
        playground.addChild(bob)
        playground.addChild(saveArea)

        
//        initAndAddEnemys()
        
        
        
        addFloater()
        
        scene?.filter
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addFloater() {
        for var i = 0; i <= 200; i++ {
            
            var randX: CGFloat
            var randY: CGFloat
            
            let radius: CGFloat = 200
            
            // (x - center_x)^2 + (y - center_y)^2 < radius^2
            
            do {
                randX = CGFloat.random(min: -600, max: 600)
                randY = CGFloat.random(min: -600, max: 600)
            } while (randX*randX) + (randY*randY) < radius*radius
            
            let floater = FloatingBacteria()
            floater.position = CGPointMake(randX, randY)
            
            let randScale : CGFloat = CGFloat.random(min: 0.3, max: 1)
            
            floater.xScale = randScale
            floater.yScale = randScale
            
            playground.addChild(floater)
        }
    }
    
    func initAndAddEnemys() {
        
        let circleBac = SKTexture(imageNamed: "circleBac.png")
        let greenBac = SKTexture(imageNamed: "greenBac.png")
        let ballChainBac = SKTexture(imageNamed: "ballChain.png")
        let pinkBac = SKTexture(imageNamed: "pinkBac.png")
        let enemysAmount = 2000
        let gameWorldSizeMin = -5000
        let gameWorldSizeMax = 5000
        
        var bacillus:SKSpriteNode
        
        for var i = 0; i <= enemysAmount; i++ {
            
            let rand = CGFloat.random()
            var ground = SKNode()
            
            if rand < 0.25 {
                bacillus = SKSpriteNode(texture: circleBac)
                ground = background2
            } else if rand < 0.5 {
                bacillus = SKSpriteNode(texture: greenBac)
                ground = playground
            } else if rand < 0.75 {
                bacillus = SKSpriteNode(texture: ballChainBac)
                ground = background1
            } else {
                bacillus = SKSpriteNode(texture: pinkBac)
                ground = playground
            }
            
//            if bacillus.position.x <= bob.position.x {
//            bacillus.physicsBody = SKPhysicsBody(texture: bacillus.texture, size: bacillus.size)
//            bacillus.physicsBody?.allowsRotation = false
//            bacillus.physicsBody?.affectedByGravity = false
//            }
            ground.addChild(bacillus)
            
            let randX = CGFloat.random(min: -5000, max: 5000)
            let randY = CGFloat.random(min: -5000, max: 5000)
            
            bacillus.position = CGPointMake(randX, randY)
            bacillus.zRotation = CGFloat.random(min: 0, max: 6.3)
        }
        
    }
    
    
}



















