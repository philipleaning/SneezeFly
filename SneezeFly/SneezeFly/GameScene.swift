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
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Sneeze Fly";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) * 1.5);
        self.addChild(myLabel)
        
        // Initialise player sprite
        playerSprite.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) * 0.5)
        playerSprite.setScale(0.5)
        
        // Add physics body to sprite
        playerSprite.physicsBody            = SKPhysicsBody(circleOfRadius: playerSprite.size.width/2.0)
        playerSprite.physicsBody?.dynamic   = true
        
        self.addChild(playerSprite)
        
        // Add physics environment
        self.physicsWorld.gravity = CGVectorMake(0.0, -3.0)
        
        sneeze()
        
        // Initialize trajectory shape
        let pathCurve = NSBezierPath()
        pathCurve.moveToPoint(NSPoint(x: 0,y: 0))
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func sneeze() {
        let sneezeSpeed: CGFloat = 500.0
        
        let newVelocity = CGVectorMake(sneezeSpeed * -sin(playerSprite.zRotation) + (playerSprite.physicsBody?.velocity.dx)!,
                                       sneezeSpeed * +cos(playerSprite.zRotation))
        
        playerSprite.physicsBody?.velocity = newVelocity

        // Draw trajectory
        let flyingTime = max(0, newVelocity.dy / -self.physicsWorld.gravity.dy)
        let sameHeightReintersectX = flyingTime * newVelocity.dx
        
        
    }
    
    override func mouseDown(theEvent: NSEvent) {
        mouseDownLocation = theEvent.locationInNode(self)
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
