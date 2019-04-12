//
//  LightDarkToggle.swift
//  Fickle
//
//  Created by Keith Irwin on 4/9/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

class LightDarkToggle: NSSegmentedControl {

    convenience init() {
        self.init(frame: NSZeroRect)
        segmentCount = 2
        setLabel("Light", forSegment: 0)
        setLabel("Dark", forSegment: 1)
        trackingMode = .selectOne
        segmentStyle = NSSegmentedControl.Style.roundRect
        segmentDistribution = NSSegmentedControl.Distribution.fit
        sizeToFit()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}
