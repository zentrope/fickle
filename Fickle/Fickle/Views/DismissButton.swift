//
//  DismissButton.swift
//  Fickle
//
//  Created by Keith Irwin on 4/9/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

class DismissButton: NSButton {

    convenience init() {
        self.init(frame: NSZeroRect)
        self.bezelStyle = .texturedSquare
        self.isBordered = false
        self.image = NSImage(named: NSImage.stopProgressFreestandingTemplateName)
        self.setButtonType(NSButton.ButtonType.momentaryPushIn)
        self.isEnabled = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}
