//
//  GameScene.swift
//  SneezeFly
//
//  Created by Philip Leaning on 29/01/2015.
//  Copyright (c) 2015 Blue Tatami Ltd. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        /*
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
        */
        
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        sprite.position = CGPoint(x: view.bounds.width/2.0, y: view.bounds.height/2.0)
        sprite.setScale(0.5)
        self.addChild(sprite)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        let location = theEvent.locationInNode(self)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
