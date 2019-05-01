//
//  ThemeImageView.swift
//  Fickle
//
//  Created by Keith Irwin on 4/30/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

class ThemeImageView: NSImageView {

    private let black = NSColor.black.cgColor
    private let white = NSColor.white.cgColor

    var theme: Theme?
    var badgeRect: CGRect { return CGRect(x: bounds.maxX - 30, y: bounds.maxY - 30, width: 20, height: 20) }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.

        guard let ctx = NSGraphicsContext.current?.cgContext else {
            return
        }

        guard let theme = theme else {
            return
        }

        ctx.setStrokeColor(theme.appearance == .light ? black : white)
        ctx.setFillColor(theme.appearance == .light ? white : black)
        ctx.setAlpha(0.8)
        ctx.setLineWidth(1)
        ctx.addEllipse(in: badgeRect)
        ctx.fillEllipse(in: badgeRect)
        ctx.strokeEllipse(in: badgeRect)
    }

    override func mouseDown(with event: NSEvent) {
        guard let theme = theme else {
            super.mouseDown(with: event)
            return
        }

        let downAt = convert(event.locationInWindow, from: nil)
        if badgeRect.contains(downAt) && event.clickCount == 1 {
            print("Double Boom")
            theme.toggleTheme()
            needsDisplay = true
            return
        }

        super.mouseDown(with: event)
    }
}
