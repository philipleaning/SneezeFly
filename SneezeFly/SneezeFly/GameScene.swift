//
//  GameScene.swift
//  SneezeFly
//
//  Created by Philip Leaning on 29/01/2015.
//  Copyright (c) 2015 Blue Tatami Ltd. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let hudNode = SKNode()
    let playerSprite        = SKSpriteNode(imageNamed: "Spaceship")
    let trajectoryShape     = SKShapeNode()
    let resetLabel = SKLabelNode(fontNamed:"Helvetica")
    
    var mouseDownLocation: CGPoint?
    
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Sneeze Fly";
        myLabel.fontSize = 65;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) * 1.5);
        self.addChild(myLabel)
                
        // Add HUD node
        self.addChild(hudNode)
        // Add reset label to HUD
        resetLabel.text = "Reset";
        resetLabel.fontSize = 65;
        resetLabel.position = CGPoint(x: self.frame.width - 100, y:self.frame.height - 60);
        self.addChild(resetLabel)

        // Initialise player sprite
        playerSprite.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) * 0.5)
        playerSprite.setScale(0.5)
        
        // Add physics body to sprite
        playerSprite.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Spaceship"), size: playerSprite.size)
        playerSprite.physicsBody?.dynamic   = false
        playerSprite.physicsBody?.categoryBitMask = 0
        playerSprite.physicsBody?.collisionBitMask = 0
        playerSprite.physicsBody?.contactTestBitMask = 1
        
        self.addChild(playerSprite)
        
        // Add physics environment
        self.physicsWorld.gravity = CGVectorMake(0.0, -3.0)
        
        // Initialize trajectory shape
        let pathCurve = NSBezierPath()
        pathCurve.moveToPoint(NSPoint(x: 0,y: 0))
        
        // Generate random stars
        for i in 1...9 {
         addRandomStar()
        }
        
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
    
    func addRandomStar() {
        let starNode = SKSpriteNode(imageNamed: "star")
        let position = CGPoint(x: CGFloat(arc4random_uniform(1000))/CGFloat(1000)*self.frame.width, y:100 + CGFloat(arc4random_uniform(1000))/CGFloat(1000)*(self.frame.height-100))

        starNode.name = "STAR_NODE"
        starNode.position = position
        starNode.setScale(0.25)
        starNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "star"), size: starNode.size)
        starNode.physicsBody?.dynamic = false
        starNode.physicsBody?.collisionBitMask = 0
        starNode.physicsBody?.categoryBitMask = 1
        
        
        self.addChild(starNode)
    }

    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "STAR_NODE" {
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.node?.name == "STAR_NODE" {
            contact.bodyB.node?.removeFromParent()
        }
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
        // Turn physics for player on
        playerSprite.physicsBody?.dynamic   = true

        sneeze()
        mouseDownLocation = nil
        
        if resetLabel.containsPoint(theEvent.locationInNode(self)) {
            playerSprite.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) * 0.5)
            playerSprite.zRotation = 0
            playerSprite.physicsBody?.dynamic = false
            playerSprite.physicsBody?.velocity = CGVectorMake(0, 0)
        }
    }
}
