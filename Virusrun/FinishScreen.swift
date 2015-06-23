//
//  FinishScreen.swift
//  Virusrun
//
//  Created by Sebastian Klotz on 16.06.15.
//  Copyright (c) 2015 Olga Koschel. All rights reserved.
//

import Foundation
import SpriteKit

class FinishScreen :SKNode {
    
    var background : SKSpriteNode = SKSpriteNode(imageNamed: "world2BG5cut.png")
    
    override init() {
        super.init()
        
        background.colorBlendFactor = 0.5
        background.color = SKColor.redColor()
        
        addChild(background)
        
    }
    
    func show() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
