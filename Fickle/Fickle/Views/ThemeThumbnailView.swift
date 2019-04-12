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

        do {
            var isStale: ObjCBool = false
            let uuu = try NSURL(resolvingBookmarkData: theme.bookmark, options: [.withoutUI, .withoutMounting, .withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &isStale) as URL

            if uuu.startAccessingSecurityScopedResource() {
                image.image = NSImage(byReferencing: uuu)
                uuu.stopAccessingSecurityScopedResource()
            }

        }
        catch let err {
            print(" error: \(err.localizedDescription)")
        }

        image.imageScaling = NSImageScaling.scaleAxesIndependently
        image.sizeThatFits(NSMakeSize(200, 100))
        image.isEditable = false
        image.wantsLayer = true

        wantsLayer = true
        layer?.borderWidth = 0
        layer?.borderColor = NSColor.controlAccentColor.cgColor
        layer?.cornerRadius = 5

        addSubview(image)

        let buffer = CGFloat(4)
        constrain(image, [
            image.topAnchor.constraint(equalTo: topAnchor, constant: buffer),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buffer),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -buffer),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -buffer)])
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    func select() {
        layer?.borderWidth = 2
    }

    func unselect() {
        layer?.borderWidth = 0
    }
}
