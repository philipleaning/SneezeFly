//
//  GameScene.swift
//  SneezeFly
//
//  Created by Philip Leaning on 29/01/2015.
//  Copyright (c) 2015 Blue Tatami Ltd. All rights reserved.
//

import SpriteKit
import CoreGraphics

class GameScene: SKScene, SKPhysicsContactDelegate {
    let hudNode = SKNode()
    let resetLabel = SKLabelNode(fontNamed:"Helvetica")
    
    let playerSprite        = SKSpriteNode(imageNamed: "Spaceship")
    
    // Curve of projected trajectory
    let trajectoryShape     = SKShapeNode()
    
    // For sneeze
    var startPoint: CGPoint!
    var sneezeAllowed = false
    
    var mouseDownLocation: CGPoint?

    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.view?.acceptsTouchEvents = true
        self.view?.wantsRestingTouches = true
        self.userInteractionEnabled = true
        
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
        if !sneezeAllowed {
            return
        }
        
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
    }
    
    override func mouseUp(theEvent: NSEvent) {
        
        if resetLabel.containsPoint(theEvent.locationInNode(self)) {
            // Move player to starting position and velocity
            playerSprite.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) * 0.5)
            playerSprite.zRotation = 0
            playerSprite.physicsBody?.dynamic = false
            playerSprite.physicsBody?.velocity = CGVectorMake(0, 0)
            
            // Hide cursor
            hideCursor()
            
            //
            sneezeAllowed = false
        }
        
        moveCursorToCenter(onlyIfCursorHidden: false)
    }
    
    override func touchesBeganWithEvent(event: NSEvent) {
        let touches = event.touchesMatchingPhase(.Began, inView: self.view)
        startPoint = (touches.allObjects.first as NSTouch).normalizedPosition

    }
    
    override func touchesMovedWithEvent(event: NSEvent) {
        let touches = event.touchesMatchingPhase(.Moved, inView: self.view)
        let endPoint = (touches.allObjects.first as NSTouch).normalizedPosition
        let directionVector = CGVectorMake(500*(endPoint.x-startPoint.x), 500*(endPoint.y-startPoint.y))
        let myAngle: CGFloat = CGFloat(M_PI) - CGFloat(atan2(directionVector.dx, directionVector.dy))
        playerSprite.zRotation = myAngle
    }
    
    override func touchesEndedWithEvent(event: NSEvent) {
        // If just pressed "Reset" button
        if sneezeAllowed {
            // Turn physics for player on if cursor is hidden
            playerSprite.physicsBody?.dynamic   = true
            
            let touches = event.touchesMatchingPhase(.Ended, inView: self.view)
            let endPoint = (touches.allObjects.first as NSTouch).normalizedPosition
            let directionVector = CGVectorMake(500*(endPoint.x-startPoint.x), 500*(endPoint.y-startPoint.y))
            let myAngle: CGFloat = CGFloat(M_PI) - CGFloat(atan2(directionVector.dx, directionVector.dy))
            playerSprite.zRotation = myAngle
            
            sneeze()
        }
        
        // Next release will fire
        sneezeAllowed = true
        
        moveCursorToCenter(onlyIfCursorHidden: true)
    }
    
    // Cursor hiding
    var cursorHidden = false
    
    func hideCursor() {
        CGDisplayHideCursor(CGMainDisplayID())
        cursorHidden = true
    }
    
    func showCursor() {
        CGDisplayShowCursor(CGMainDisplayID())
        cursorHidden = false
    }
    
    func moveCursorToCenter(#onlyIfCursorHidden: Bool) {
        if (onlyIfCursorHidden && !cursorHidden) {
            return
        }
        if let myView = self.view {
            if let myWindow = myView.window {
                if let myScreen = myWindow.screen {
                    let frameRelativeToScreen = myWindow.convertRectToScreen(myView.frame)
                    let screenMaxY = myScreen.frame.maxY
                    let middleOfScenePoint      = CGPoint(x: CGRectGetMidX(frameRelativeToScreen), y:  screenMaxY - CGRectGetMidY(frameRelativeToScreen))
                    CGDisplayMoveCursorToPoint(CGMainDisplayID(), middleOfScenePoint)
                }
            }
        }
    }
}

// keyboard handling
extension GameScene {
    override func keyDown(theEvent: NSEvent) {
        handleKeyEvent(theEvent: theEvent, keyDown: true)
    }
    
    override func keyUp(theEvent: NSEvent) {
        handleKeyEvent(theEvent: theEvent, keyDown: false)
    }
    
    func handleKeyEvent(theEvent event: NSEvent, keyDown: Bool) {
        if !keyDown {
            if let characters = event.characters {
                for character: Character in characters {
                    switch character {
                    case Character(" "):
                        showCursor()
                    default:
                        break
                    }
                }
            }
        }
    }
}
