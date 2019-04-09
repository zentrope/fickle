//
//  Model.swift
//  Fickle
//
//  Created by Keith Irwin on 4/8/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Foundation

enum Appearance: String, Codable {
    case light = "light"
    case dark = "dark"
}

struct Theme: Codable {
    var backgroundImageURL: URL
    var appearance: Appearance
}
