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
        let contextMenu = NSMenu()
        let icon = NSMenuItem()
        icon.image = NSImage(named: NSImage.actionTemplateName)
        icon.isHidden = true
        icon.title = ""

        contextMenu.addItem(icon)

        menu = contextMenu
        pullsDown = true
        bezelStyle = NSButton.BezelStyle.roundRect
        isEnabled = true
        preferredEdge = NSRectEdge.maxY
        autoenablesItems = true
        isBordered = false

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
