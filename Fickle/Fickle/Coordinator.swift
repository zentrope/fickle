//
//  Coordinator.swift
//  Fickle
//
//  Created by Keith Irwin on 4/7/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

import os.log

fileprivate let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Coordinator")

class Coordinator: NSObject {

    override init() {
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: "AppleInterfaceStyle", options: [], context: nil)
    }

    func setAppearance(_ mode: AppearanceMode) -> Bool {
        switch mode {
        case .light:
            if !Appearance.isDark() { return true }
            os_log("%{public}s", log: logger, "setting appearance to light")
            return Appearance.setAppearance(.light)

        case .dark:
            if Appearance.isDark() { return true }
            os_log("%{public}s", log: logger, "setting appearance to dark")
            return Appearance.setAppearance(.dark)
        }
    }

    func isDark() -> Bool {
        return Appearance.isDark()
    }

    func isLight() -> Bool {
        return !isDark()
    }

    func quit() {
        NSApp.terminate(self)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let app = String(describing: UserDefaults.standard.string(forKey: "AppleInterfaceStyle"))
        os_log("%{public}s", log: logger, "observed appearance of \(app)")
    }
}

enum AppearanceMode : String {
    case dark = "true"
    case light = "false"
}

fileprivate struct Appearance {

    static let template = """
    tell application "System Events"
      tell appearance preferences
        set dark mode to %@
      end tell
    end tell
    """


    static func isDark() -> Bool {
        let appearance = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
        os_log("%{public}s", log: logger, "appearance is `\(String(describing: appearance))`")
        return UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
    }

    static func setAppearance(_ mode: AppearanceMode) -> Bool {
        let source = String(format: template, mode.rawValue)
        var error: NSDictionary?
        if let script = NSAppleScript(source: source) {
            if let msg = script.executeAndReturnError(&error).stringValue {
                os_log("%{public}s", log: logger, "script return: \(msg)")
            }
            if let error = error {
                os_log("%{public}s", log: logger, type: .error, "\(error)")
                return false
            }
            UserDefaults.standard.set(mode.rawValue == "true" ? "Dark" : "Light", forKey: "AppleInterfaceStyle")
        }
        return true
    }
}
