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

extension Theme: Equatable {
    static func ==(lhs: Theme, rhs: Theme) -> Bool {
        // It's possible to use the same background with different
        // appearances. If that's not good, just check the URLs.
        return lhs.backgroundImageURL == rhs.backgroundImageURL &&
            lhs.appearance == rhs.appearance
    }
}
