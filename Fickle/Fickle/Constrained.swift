//
//  Constrained.swift
//  Fickle
//
//  Created by Keith Irwin on 4/8/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

protocol Constrained: AnyObject {}

extension Constrained {
    func constrain(_ field: NSView, _ constraints: [NSLayoutConstraint]) {
        field.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

}
