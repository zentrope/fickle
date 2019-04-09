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

    var data = [Theme]()

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

    func dropURL(url: URL) {
        print("Got a drop", url)
        data.append(Theme(backgroundImageURL: url, appearance: .light))
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


extension AppController: ImageListViewDelegate {

    func selected(row: Int) {
        if row < 0 { return }
        let theme = data[row]
        guard let screen = NSScreen.main else { return }
        guard let options = NSWorkspace.shared.desktopImageOptions(for: screen) else { return }

        do {
            // NOTE: Setting options myself always dumps a stack trace.
            try NSWorkspace.shared.setDesktopImageURL(theme.backgroundImageURL, for: screen, options: options)
        }
        catch let error {
            os_log("%{public}s", log: logger, type: .error, error.localizedDescription)
        }
    }
}

fileprivate var lastSelection = -1

extension AppController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return ThemeThumbnailView(theme: data[row])
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else { return }
        let selection = tableView.selectedRow

        tableView.enumerateAvailableRowViews { (view, row) in
            if let v = view.view(atColumn: 0) as? ThemeThumbnailView {
                if row == selection {
                    v.select()
                    return
                }
                if row == lastSelection {
                    v.unselect()
                }
            }
        }
        lastSelection = selection
    }
}

// MARK: - NSTableViewDataSource

extension AppController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return data.count
    }

}
