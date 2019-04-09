//
//  AppController.swift
//  Fickle
//
//  Created by Keith Irwin on 4/7/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

import os.log

fileprivate let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "AppController")

class AppController: NSObject {

    weak var mainWindow: NSWindow?

    override init() {
        super.init()
    }

    // MARK: - Public Interface

    enum AppearanceMode : String {
        case dark = "true"
        case light = "false"
    }

    func setAppearance(_ mode: AppController.AppearanceMode) {
        switch mode {
        case .light:
            sendAppearanceScript(.light)

        case .dark:
            sendAppearanceScript(.dark)
        }
    }

    func quit() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.terminate(self)
    }

    func close() {
        mainWindow?.close()
    }

    // MARK: - Implementation details

    private let template = """
    tell application "System Events"
      tell appearance preferences
        set dark mode to %@
      end tell
    end tell
    """

    private func sendAppearanceScript(_ mode: AppearanceMode) {
        let source = String(format: template, mode.rawValue)
        var error: NSDictionary?
        if let script = NSAppleScript(source: source) {
            if let msg = script.executeAndReturnError(&error).stringValue {
                os_log("%{public}s", log: logger, "script return: \(msg)")
            } else {
                os_log("%{public}s", log: logger, "script executed for \(mode) appearance")
            }
            if let error = error {
                os_log("%{public}s", log: logger, type: .error, "\(error)")
            }
        }
    }
}
