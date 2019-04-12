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
fileprivate let scriptlog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "ScriptRunner")

class AppController: NSObject {

    weak var mainWindow: NSWindow?

    var data = [Theme]()

    override init() {
        super.init()
        Storage.load() {
            self.data = $0
        }
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

    private let showInFinderTemplate = """
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

    private func sendShowInFinderTemplate(_ url: URL) {
        let file = url.path
        let path = url.deletingLastPathComponent().path
        let source = String(format: showInFinderTemplate, path, file)
        execScript(source, to: "show '\(file)' in finder")
    }

    private func sendAppearanceScript(_ mode: AppearanceMode) {
        let source = String(format: template, mode.rawValue)
        execScript(source, to: "set appearance to '\(mode)'")
    }

    private func execScript(_ source: String, to name: String) {
        var error: NSDictionary?
        if let script = NSAppleScript(source: source) {
            if let msg = script.executeAndReturnError(&error).stringValue {
                os_log("%{public}s", log: scriptlog, "script return: \(msg)")
            } else {
                os_log("%{public}s", log: scriptlog, "script executed to \(name)")
            }
            if let error = error {
                os_log("%{public}s", log: scriptlog, type: .error, "\(error)")
            }
        }
    }
}

// MARK: - ImageListViewDelegate

extension AppController: ImageListViewDelegate {

    func delete(row: Int) {
        if row < data.count {
            data.remove(at: row)
            Storage.save(data)
        }
    }

    func selected(row: Int) {
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

    func show(row: Int) {
        let theme = data[row]
        sendShowInFinderTemplate(theme.backgroundImageURL)
    }
}

// MARK: - NSTableViewDelegate

extension AppController: NSTableViewDelegate {

    // View for given row/column
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return ThemeThumbnailView(theme: data[row])
    }

    // Row height
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }

    // Encode theme to be drag and dropped
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        let item = NSPasteboardItem()
        item.setString("\(row)", forType: .string)
        return item
    }

    // Validate drop operation
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {

        guard dropOperation == .above else { return [] }

        tableView.draggingDestinationFeedbackStyle = .gap
        return .move
    }

    // Accept the drop
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {

        // Strings might be row integers
        if let strings = info.draggingPasteboard.pasteboardItems {
            let indexes = strings
                .compactMap { $0.string(forType: .string) }
                .compactMap { Int($0) }
                .filter { $0 < data.count }
            indexes.forEach { fromRow in
                let toRow = fromRow > row ? row : row - 1
                // TODO: Does this need to be atomic?
                tableView.moveRow(at: fromRow, to: toRow)
                data.swapAt(fromRow, toRow)
            }
            if !indexes.isEmpty {
                tableView.selectRowIndexes([], byExtendingSelection: false)
                Storage.save(data)
                return true
            }
        }

        if let urls = info.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: [:]) as? [URL] {
            if urls.isEmpty { return false }
            let themes = urls.map {
                Theme(backgroundImageURL: $0,
                      appearance: .light,
                      bookmark: try! $0.bookmarkData(options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess], includingResourceValuesForKeys: nil, relativeTo: nil)
                )

                }
                .filter { !data.contains($0) }
            if themes.isEmpty { return false }

            data.insert(contentsOf: themes, at: row)
            tableView.insertRows(at: IndexSet(row...row + themes.count - 1), withAnimation: .slideDown)
        }
        tableView.selectRowIndexes([], byExtendingSelection: false)
        Storage.save(data)
        return true
    }

    // Handle selection change
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard let tableView = notification.object as? NSTableView else { return }
        let selection = tableView.selectedRow

        tableView.enumerateAvailableRowViews { (view, row) in
            if let v = view.view(atColumn: 0) as? ThemeThumbnailView {
                if row == selection {
                    v.select()
                } else {
                    v.unselect()
                }
            }
        }
    }
}

// MARK: - NSTableViewDataSource

extension AppController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return data.count
    }

}
