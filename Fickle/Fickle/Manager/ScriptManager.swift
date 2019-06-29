//
//  ScriptManager.swift
//  Fickle
//
//  Created by Keith Irwin on 6/28/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Foundation
import os.log

fileprivate let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "ScriptManager")

struct ScriptManager {
    
    enum Appearance : String {
        case dark = "true"
        case light = "false"
    }

    static let template = """
    tell application "System Events"
      tell appearance preferences
        set dark mode to %@
      end tell
    end tell
    """

    static let showInFinderTemplate = """
    set theFolder to (POSIX file "%@") as alias
    set theFile to (POSIX FILE "%@") as alias
    tell application "Finder"
        activate
        if window 1 exists then
            set target of window 1 to theFolder
        end if
        reveal theFile
    end tell
    """

    static func sendShowInFinderTemplate(_ url: URL) {
        let file = url.path
        let path = url.deletingLastPathComponent().path
        let source = String(format: showInFinderTemplate, path, file)
        execScript(source, to: "show '\(file)' in finder")
    }

    static func sendAppearanceScript(_ mode: Appearance) {
        let source = String(format: template, mode.rawValue)
        execScript(source, to: "set appearance to '\(mode)'")
    }

    static func execScript(_ source: String, to name: String) {
        var error: NSDictionary?
        if let script = NSAppleScript(source: source) {
            if let msg = script.executeAndReturnError(&error).stringValue {
                os_log("%{public}s", log: logger, "script return: \(msg)")
            } else {
                os_log("%{public}s", log: logger, "script executed to \(name)")
            }
            if let error = error {
                os_log("%{public}s", log: logger, type: .error, "\(error)")
            }
        }
    }

}
