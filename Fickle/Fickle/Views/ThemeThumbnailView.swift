//
//  ThemeThumbnailView.swift
//  Fickle
//
//  Created by Keith Irwin on 4/8/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

class ThemeThumbnailView: NSView, Constrained {

    var image = NSImageView()

    convenience init(theme: Theme) {
        self.init(frame: NSMakeRect(0, 0, 200, 100))

        image = NSImageView()
        image.image = NSImage(byReferencing: theme.backgroundImageURL)
        image.imageScaling = NSImageScaling.scaleAxesIndependently
        image.sizeThatFits(NSMakeSize(200, 100))
        image.isEditable = false
        image.wantsLayer = true

        wantsLayer = true
        layer?.borderWidth = 0
        layer?.borderColor = NSColor.controlAccentColor.cgColor
        addSubview(image)

        constrain(image, [
            image.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            image.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    func select() {
        layer?.borderWidth = 4
    }

    func unselect() {
        layer?.borderWidth = 0
    }
}
