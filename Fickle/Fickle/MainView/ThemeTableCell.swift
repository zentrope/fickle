//
//  Thumbnail.swift
//  Fickle
//
//  Created by Keith Irwin on 4/8/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

class ThemeTableCell: NSView {

    var image = ThemeImageView()

    var theme: Theme? {
        didSet {
            image.theme = theme
            guard let theme = theme else { return }
            do {
                var isStale: ObjCBool = false
                let uuu = try NSURL(resolvingBookmarkData: theme.bookmark, options: [.withoutUI, .withoutMounting, .withSecurityScope], relativeTo: nil, bookmarkDataIsStale: &isStale) as URL

                if uuu.startAccessingSecurityScopedResource() {
                    image.image = NSImage(byReferencing: uuu)
                        .resized(to: NSMakeSize(200, 100))
                    uuu.stopAccessingSecurityScopedResource()
                }
            }
            catch let err {
                print(" error: \(err.localizedDescription)")
            }
        }
    }

    convenience init(identifier: NSUserInterfaceItemIdentifier) {
        self.init(frame: NSMakeRect(0, 0, 200, 100))
        self.identifier = identifier
        focusRingType = .none

        image.isEditable = false
        image.wantsLayer = true
        image.focusRingType = .none

        wantsLayer = true
        layer?.borderWidth = 0
        layer?.borderColor = NSColor.controlAccentColor.cgColor
        layer?.cornerRadius = 4

        addSubview(image)

        let buffer = CGFloat(4)

        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: buffer),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buffer),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -buffer),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -buffer)
            ])
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        layer?.borderColor = NSColor.controlAccentColor.cgColor
    }

    func select() {
        layer?.borderWidth = 3
    }

    func unselect() {
        layer?.borderWidth = 0
    }
}
