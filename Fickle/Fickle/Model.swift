//
//  Model.swift
//  Fickle
//
//  Created by Keith Irwin on 4/8/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Foundation

import os.log

enum Appearance: String, Codable {
    case light = "light"
    case dark = "dark"
}

struct Theme: Codable {
    var backgroundImageURL: URL
    var appearance: Appearance
    var bookmark: Data
}

extension Theme: Equatable {
    static func ==(lhs: Theme, rhs: Theme) -> Bool {
        // It's possible to use the same background with different
        // appearances. If that's not good, just check the URLs.
        return lhs.backgroundImageURL == rhs.backgroundImageURL &&
            lhs.appearance == rhs.appearance
    }
}

fileprivate let savelog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Save")
fileprivate let loadlog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Load")

struct Storage {

    private static let filename = "themes.json"

    private static func location() -> URL {
        return FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("themes.json")
    }

    private static func ensure(_ url: URL) throws {
        let fileManager = FileManager.default
        let parent = url.deletingLastPathComponent()
        try fileManager.createDirectory(at: parent, withIntermediateDirectories: true, attributes: [:])
    }

    static func load(_ completion: @escaping ([Theme]) -> ()) {
        DispatchQueue.global().async {
            do {
                let url = location()
                try ensure(url)
                os_log("%{public}s", log: loadlog, "loading from `\(url)`")
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let themes = try decoder.decode([Theme].self, from: data)
                os_log("%{public}s", log: loadlog, "loaded \(themes.count) themes from local storage")
                completion(themes)
                //return themes
            } catch let error {
                os_log("%{public}s", log: loadlog, type: .error, error.localizedDescription)
                completion([Theme]())
                //return [Theme]()
            }
        }
    }

    static func save(_ themes: [Theme]) {
        DispatchQueue.global().async {
            do {
                let url = location()
                try ensure(url)
                os_log("%{public}s", log: savelog, "saving to `\(url)`")
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let data = try encoder.encode(themes)
                try data.write(to: url)
                os_log("%{public}s", log: savelog, "saved \(themes.count) themes to local storage")
            } catch let error {
                os_log("%{public}s", log: savelog, type: .error, error.localizedDescription)
            }
        }
    }
}
