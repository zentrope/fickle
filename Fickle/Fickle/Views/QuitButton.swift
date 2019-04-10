//
//  QuitButton.swift
//  Fickle
//
//  Created by Keith Irwin on 4/9/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

class QuitButton: NSButton {

    convenience init() {
        self.init(frame: NSZeroRect)
        self.bezelStyle = NSButton.BezelStyle.roundRect
        self.title = "Quit"
        self.isEnabled = true
        self.sizeToFit()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}
