//
//  TouchForwardingSKView.swift
//  SneezeFly
//
//  Created by Philip Leaning on 30/01/2015.
//  Copyright (c) 2015 Blue Tatami Ltd. All rights reserved.
//

import Foundation
import SpriteKit

class TouchableSKView: SKView {
    
    override func touchesBeganWithEvent(event: NSEvent) {
        self.scene?.touchesBeganWithEvent(event)
    }
 
    override func touchesEndedWithEvent(event: NSEvent) {
        self.scene?.touchesEndedWithEvent(event)
    }
    
    override func touchesMovedWithEvent(event: NSEvent) {
        self.scene?.touchesMovedWithEvent(event)
    }
}
