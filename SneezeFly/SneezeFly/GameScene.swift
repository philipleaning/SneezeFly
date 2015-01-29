//
//  GameScene.swift
//  SneezeFly
//
//  Created by Philip Leaning on 29/01/2015.
//  Copyright (c) 2015 Blue Tatami Ltd. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let playerSprite        = SKSpriteNode(imageNamed: "Spaceship")
    let trajectoryShape     = SKShapeNode()
    
    var mouseDownLocation: CGPoint?
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        /*
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Sneeze Fly";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) * 1.5);
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
    
    override func mouseDragged(theEvent: NSEvent) {
        if let startLocation = mouseDownLocation {
            let shipDirectionVector = CGVectorMake( theEvent.locationInNode(self).x - startLocation.x,
                                                    theEvent.locationInNode(self).y - startLocation.y)
            let myAngle: CGFloat = CGFloat(M_PI) - CGFloat(atan2(shipDirectionVector.dx, shipDirectionVector.dy))
            playerSprite.zRotation = myAngle
        }
    }
    
    override func mouseUp(theEvent: NSEvent) {
        sneeze()
        mouseDownLocation = nil
    }
}
