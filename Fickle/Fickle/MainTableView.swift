//
//  MainTableView.swift
//  Fickle
//
//  Created by Keith Irwin on 4/7/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

class GridClipTableView: NSTableView {
    // This prevents tables from showing gridlines for empty
    // underflow cells.
    override func drawGrid(inClipRect clipRect: NSRect) { }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
}

class MainTableView: NSView {

    private var container = NSScrollView()

    convenience init() {
        self.init(frame: NSZeroRect)
        setupTableView()
        setupLayout()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    private func setupTableView() {
        let tableView = GridClipTableView()
        tableView.gridStyleMask = .solidHorizontalGridLineMask
        tableView.selectionHighlightStyle = .regular
        tableView.headerView = nil
        //tableView.usesAutomaticRowHeights = false
        tableView.rowSizeStyle = NSTableView.RowSizeStyle.custom

        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("column"))
        column.isEditable = false

        tableView.addTableColumn(column)

        container.documentView = tableView
        container.hasVerticalScroller = true
        addSubview(container)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    private func constrain(_ field: NSView, _ constraints: [NSLayoutConstraint]) {
        field.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

    private func setupLayout() {
        constrain(container, [
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

}

extension MainTableView: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        // Just return the row to see if all this works.

        let field = NSTextField()
        field.isEditable = false
        field.isBordered = true
        field.isBezeled = false
        field.isSelectable = false
        field.drawsBackground = false

        field.stringValue = "\(row)"
        field.sizeToFit()

        let image = NSImageView()
        // Can't explicitly name files when in AppSandbox mode.
        //image.image = NSImage(byReferencing: URL(fileURLWithPath: "/Users/foo/bar.png"))
        image.sizeThatFits(NSMakeSize(200, 100))
        image.imageScaling = NSImageScaling.scaleAxesIndependently
        image.wantsLayer = true
        image.layer?.backgroundColor = NSColor.systemGreen.cgColor

        image.sizeToFit()
        let view = NSView(frame: NSZeroRect)
        view.addSubview(image)
        view.addSubview(field)

        constrain(image, [
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7),
            image.widthAnchor.constraint(equalToConstant: 200),
            image.heightAnchor.constraint(equalToConstant: 100)
            ])

        constrain(field, [
            field.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            field.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 7),
            field.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7)
        ])

        return view
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 110
    }
}

extension MainTableView: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return 10
    }

}
