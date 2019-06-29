//
//  ImageListView.swift
//  Fickle
//
//  Created by Keith Irwin on 4/7/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa
import os.log

fileprivate let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "ThemeTableView")

class ThemeTableView: NSView, NSTableViewDataSource, NSTableViewDelegate {

    enum Event {
        case delete(themes: [Theme], index: Int)
        case select(theme: Theme)
        case reveal(theme: Theme)
    }

    var action: ((Event) -> Void)?

    private class GridClipTableView: NSTableView {
        override func drawGrid(inClipRect clipRect: NSRect) { }
    }

    private var scrollView = NSScrollView()
    private var tableView = GridClipTableView()
    private var contextMenu = NSMenu()

    private var deleteMenu = NSMenuItem(title: "Delete", action: #selector(delete(_:)), keyEquivalent: "")
    private var revealMenu = NSMenuItem(title: "Reveal in Finder", action: #selector(show(_:)), keyEquivalent: "")
    private var selectMenu = NSMenuItem(title: "Select", action: #selector(select(_:)), keyEquivalent: "")

    private(set) var data = [Theme]()

    convenience init() {
        self.init(frame: .zero)

        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("column"))
        column.isEditable = false

        tableView = GridClipTableView()
        tableView.registerForDraggedTypes([NSPasteboard.PasteboardType.URL, .string])
        tableView.intercellSpacing = NSMakeSize(4, 0)
        tableView.selectionHighlightStyle = .none
        tableView.headerView = nil
        tableView.target = self
        tableView.doubleAction = #selector(select(_:))
        tableView.addTableColumn(column)

        scrollView.borderType = .noBorder
        scrollView.documentView = tableView
        scrollView.hasVerticalScroller = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])

        tableView.menu = contextMenu
        contextMenu.addItem(selectMenu)
        contextMenu.addItem(revealMenu)
        contextMenu.addItem(deleteMenu)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func setData(_ data: [Theme]) {
        self.data = data
        reload()
    }

    func reload() {
        tableView.reloadData()
    }

    @objc func show(_ sender: Any) {
        let row = tableView.clickedRow
        guard row > -1 else { return }
        action?(.reveal(theme: data[row]))
        //NotificationCenter.default.post(name: .applicationDidClickRevealThemeLocation, object: self, userInfo: ["theme": data[row]])
    }

    @objc func delete(_ sender: NSMenuItem) {
        let row = tableView.clickedRow
        guard row > -1 else { return }
        action?(.delete(themes: data, index: row))
        tableView.removeRows(at: IndexSet([row]), withAnimation: .effectFade)
    }
    
    @objc func select(_ sender: Any) {
        let row = tableView.clickedRow
        guard row > -1 else { return }
        action?(.select(theme: data[row]))
    }

    // MARK: NSTableViewDelegate

    // View for given row/column
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let identifier = tableColumn?.identifier else { return nil }
        var cell: ThemeTableCell
        if let oldcell = tableView.makeView(withIdentifier: identifier, owner: self) as? ThemeTableCell {
            cell = oldcell
        } else {
            cell = ThemeTableCell(identifier: identifier)
        }

        cell.theme = data[row]
        return cell
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

            if !indexes.isEmpty {
                data.move(with: IndexSet(indexes) , to: row)
                tableView.beginUpdates()
                var oldIndexOffset = 0
                var newIndexOffset = 0
                for oldIndex in indexes {
                    if oldIndex < row {
                        tableView.removeRows(at: IndexSet([oldIndex + oldIndexOffset]), withAnimation: .effectFade)
                        tableView.insertRows(at: IndexSet([row - 1]), withAnimation: .effectGap)
                        oldIndexOffset -= 1
                    } else {
                        tableView.removeRows(at: IndexSet([oldIndex]), withAnimation: .effectFade)
                        tableView.insertRows(at: IndexSet([row + newIndexOffset]), withAnimation: .effectGap)
                        newIndexOffset += 1
                    }
                }
                tableView.endUpdates()
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
            tableView.insertRows(at: IndexSet(row...row + themes.count - 1), withAnimation: .effectGap)
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
            if let v = view.view(atColumn: 0) as? ThemeTableCell {
                if row == selection {
                    v.select()
                } else {
                    v.unselect()
                }
            }
        }
    }

    // MARK: NSTableViewDataSource

    func numberOfRows(in tableView: NSTableView) -> Int {
        return data.count
    }
}
