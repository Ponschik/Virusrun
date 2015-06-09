//
//  Interface.swift
//  Virusrun
//
//  Created by Olga Koschel on 25.05.15.
//  Copyright (c) 2015 Olga Koschel. All rights reserved.
//

import Foundation
import SpriteKit

class Interface: SKNode {
    
    let amplifyNode = SKNode()
    let linearDamping = SKNode()
    let shakeFilter = SKNode()
    
//    
//    let arrowTxtr : SKTexture! = SKTexture(imageNamed: "right.png")
//    
//    let ampUp : SKSpriteNode
    
    override init() {
        super.init()
        
        
//        self.bubbleDown = [SKSpriteNode spriteNodeWithImageNamed:@"right.png"];
//        self.bubbleDown.zRotation = M_PI;
//        self.bubbleDown.position = CGPointMake(-400, 0);
//        [self.interface addChild:self.bubbleDown];
//        
//        self.bubbleUp = [SKSpriteNode spriteNodeWithImageNamed:@"right.png"];
//        self.bubbleUp.position = CGPointMake(400, 0);
//        [self.interface addChild:self.bubbleUp];
//        
//        self.amplifyLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"%.2f", self.amplify]];
//        self.amplifyLabel.fontColor = [SKColor blackColor];
//        self.amplifyLabel.position = CGPointMake(0, 300);
//        [self.interface addChild:self.amplifyLabel];
//        
//        self.ampDown = [SKSpriteNode spriteNodeWithImageNamed:@"right.png"];
//        self.ampDown.zRotation = M_PI;
//        self.ampDown.position = CGPointMake(-100, 310);
//        [self.interface addChild:self.ampDown];
//        
//        self.ampUp = [SKSpriteNode spriteNodeWithImageNamed:@"right.png"];
//        self.ampUp.position = CGPointMake(100, 310);
//        [self.interface addChild:self.ampUp];
        
        let shakeFilterLabel = SKLabelNode();
        shakeFilterLabel.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1)
        shakeFilterLabel.position = CGPointMake(0, -300);
//        shakeFilter.addChild(shakeFilterLabel)
        
        let shakeDown = SKSpriteNode(imageNamed: "right.png")
        shakeDown.zRotation = CGFloat(M_PI);
        shakeDown.position = CGPointMake(-100, -290);
//        shakeFilter.addChild(shakeDown);
        
        let shakeUp = SKSpriteNode(imageNamed: "right.png")
        shakeUp.position = CGPointMake(100, -290);
//        shakeFilter.addChild(shakeUp)
        
        addChild(shakeFilter)
        
    }
    
    func updateShakeLabel(shakeFilter:Float){
//        shakeFilter.
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        
        let touchLocation = touch.locationInNode(self)
        
        println("waddup")
//        if([yourSprite containsPoint: touchLocation])
//        {
//            //sprite contains touch
//        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}