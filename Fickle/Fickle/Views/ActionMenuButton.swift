//
//  ActionMenuButton.swift
//  Fickle
//
//  Created by Keith Irwin on 4/11/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

class ActionMenuButton: NSPopUpButton {

    convenience init() {
        self.init(frame: NSMakeRect(0, 0, 28, 32))
        let menu = NSMenu()
        let icon = NSMenuItem()
        icon.image = NSImage(named: NSImage.actionTemplateName)
        icon.isHidden = true
        icon.title = ""

        menu.addItem(icon)

        self.menu = menu
        self.pullsDown = true
        self.bezelStyle = NSButton.BezelStyle.roundRect
        self.isEnabled = true
        self.preferredEdge = NSRectEdge.maxY
        self.autoenablesItems = true

        if let cell = self.cell as? NSPopUpButtonCell {
            cell.arrowPosition = NSPopUpButton.ArrowPosition.noArrow
            cell.usesItemFromMenu = true
            cell.pullsDown = true
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}
