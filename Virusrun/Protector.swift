//
//  Protector.swift
//  Virusrun
//
//  Created by Olga Koschel on 09.06.15.
//  Copyright (c) 2015 Olga Koschel. All rights reserved.
//

import Foundation
import SpriteKit

class Protector: SKNode {
    
    let protector = SKSpriteNode(imageNamed: "protector.png")
//    let protector = SKSpriteNode(imageNamed: "protector.png")

    override init(){
        super.init()
        
//        self.arrowBox = [SKNode new];
//        self.arrowBox.zPosition = 10;
//        //    [self.crossworld.playground addChild:self.arrowBox];
//        
//        self.magnetArrow = [SKSpriteNode spriteNodeWithImageNamed:@"equalTriangleCut.png"];
//        self.magnetArrow.position = CGPointMake(150, 0);
//        self.magnetArrow.zPosition = 10;
        
//        .magnetArrow.physicsBody = [SKPhysicsBody bodyWithTexture:self.magnetArrow.texture size:self.magnetArrow.texture.size];
//        self.magnetArrow.physicsBody.affectedByGravity = NO;
//        self.magnetArrow.physicsBody.dynamic = YES;
//        self.magnetArrow.physicsBody.categoryBitMask = ArrowCollisionType;
//        self.magnetArrow.physicsBody.contactTestBitMask = BubbleCollisionType;
//        self.magnetArrow.physicsBody.collisionBitMask = 0;
        
        zPosition = 20
        
        
//        protector.position = CGPointMake(150, 0)
        protector.zPosition = 20
        
        protector.physicsBody = SKPhysicsBody(texture: protector.texture, size: protector.size)
        protector.physicsBody?.categoryBitMask = CollisionType.Protector.rawValue
        protector.physicsBody?.contactTestBitMask = CollisionType.Attacker.rawValue
        protector.physicsBody?.collisionBitMask = 0//CollisionType.Floater.rawValue | CollisionType.Attacker.rawValue
        protector.physicsBody?.fieldBitMask = 0
        protector.physicsBody?.affectedByGravity = false
        protector.physicsBody?.dynamic = true
//        arrow.physicsBody?.collisionBitMask = 0
        
        xScale = 0.85
        yScale = 0.85
        
        addChild(protector)
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}