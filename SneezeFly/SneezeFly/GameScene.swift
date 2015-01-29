//
//  GameScene.swift
//  SneezeFly
//
//  Created by Philip Leaning on 29/01/2015.
//  Copyright (c) 2015 Blue Tatami Ltd. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let playerSprite = SKSpriteNode(imageNamed: "Spaceship")
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
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func sneeze() {
        playerSprite.physicsBody?.velocity.dy = 0
        
        let sneezeMagnitude: CGFloat = 500.0
        let sneezeVector             = CGVectorMake(sneezeMagnitude * -sin(playerSprite.zRotation),
                                                    sneezeMagnitude * +cos(playerSprite.zRotation))
        playerSprite.physicsBody?.applyImpulse(sneezeVector)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        mouseDownLocation = theEvent.locationInNode(self)
        
        
        //        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        //        sprite.runAction(SKAction.repeatActionForever(action))
        
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        println("dragged")
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
