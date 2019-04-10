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
        self.segmentCount = 2
        self.setLabel("Light", forSegment: 0)
        self.setLabel("Dark", forSegment: 1)
        self.trackingMode = .selectOne
        self.segmentStyle = NSSegmentedControl.Style.roundRect
        self.segmentDistribution = NSSegmentedControl.Distribution.fit
        self.sizeToFit()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}
