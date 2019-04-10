//
//  ImageListView.swift
//  Fickle
//
//  Created by Keith Irwin on 4/7/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa
import os.log

fileprivate let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "ImageListView")

class GridClipTableView: NSTableView {
    // This prevents tables from showing gridlines for empty
    // underflow cells.
    override func drawGrid(inClipRect clipRect: NSRect) { }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
}

protocol ImageListViewDelegate {
    func selected(row: Int)
}

// Rename theme list view?
class ImageListView: NSView, Constrained {

    private var container = NSScrollView()
    private var tableView = GridClipTableView()

    var delegate: ImageListViewDelegate?

    var tableDelegate: NSTableViewDelegate? {
        didSet {
            tableView.delegate = tableDelegate
        }
    }

    var tableDataSource: NSTableViewDataSource? {
        didSet {
            tableView.dataSource = tableDataSource
        }
    }

    convenience init() {
        self.init(frame: NSZeroRect)
        setupTableView()
        setupLayout()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    func reload() {
        tableView.reloadData()
    }

    // MARK: - Implementation details

    private func setupTableView() {
        container.borderType = NSBorderType.noBorder
        container.contentInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        container.automaticallyAdjustsContentInsets = false
        
        tableView = GridClipTableView()
        tableView.registerForDraggedTypes([NSPasteboard.PasteboardType.URL, .string])
        tableView.intercellSpacing = NSMakeSize(0, 4)
        tableView.selectionHighlightStyle = .none
        tableView.headerView = nil
        tableView.target = self
        tableView.doubleAction = #selector(doubleAction(_:))

        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("column"))
        column.isEditable = false

        tableView.addTableColumn(column)

        container.documentView = tableView
        container.hasVerticalScroller = true
        addSubview(container)

        tableView.reloadData()
    }

    private func setupLayout() {
        constrain(container, [
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    // MARK: - Actions

    @objc func doubleAction(_ sender: NSTableView) {
        delegate?.selected(row: sender.clickedRow)
    }
}
