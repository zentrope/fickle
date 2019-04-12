//
//  ViewController.swift
//  Fickle
//
//  Created by Keith Irwin on 4/6/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa
import os.log

fileprivate let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "ViewController")

class ViewController: NSViewController, Constrained {

    // MARK: - Controls

    private var toggle         = LightDarkToggle()
    private var dismissButton  = DismissButton()
    private var tableContainer = ImageListView()
    private var actionButton   = ActionMenuButton()

    // MARK: - AppController

    var appController: AppController?

    // MARK: - Lifecycle

    override func loadView() {
        let view = NSView(frame: NSMakeRect(0, 0, 400, 600))
        view.wantsLayer = true
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        toggle.target = self
        toggle.action = #selector(doToggle(_:))
        dismissButton.target = self
        dismissButton.action = #selector(doClose(_:))

        setupToggle()
        setupLayout()
        setupAppearanceObserver()
        setupActionMenu()

        tableContainer.delegate = appController
        tableContainer.tableDelegate = appController
        tableContainer.tableDataSource = appController

        tableContainer.reload()
    }

    // MARK: - Implementation

    private var observer: NSKeyValueObservation?

    private func setupAppearanceObserver() {
        observer = view.observe(\.effectiveAppearance) { (_, _) in
            self.setupToggle()
        }
    }

    private func isDark() -> Bool {
        return view.effectiveAppearance.name == .darkAqua
    }

    private func isLight() -> Bool {
        return !isDark()
    }

    private func setupActionMenu() {
        let quit = NSMenuItem(title: "Quit", action: #selector(doQuit(_:)), keyEquivalent: "q")
        let desk = NSMenuItem(title: "Reveal Apple Desktop Pictures", action: #selector(doDesktopPictures(_:)), keyEquivalent: "l")

        actionButton.menu?.addItem(desk)
        actionButton.menu?.addItem(NSMenuItem.separator())
        actionButton.menu?.addItem(quit)
    }

    private func setupToggle() {
        toggle.selectedSegment = isDark() ? 1 : 0
    }

    private func setupLayout() {
        view.addSubview(dismissButton)
        view.addSubview(toggle)
        view.addSubview(tableContainer)

        view.addSubview(actionButton)

        constrain(dismissButton, [
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 9),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            dismissButton.widthAnchor.constraint(equalToConstant: 19)
            ])

        constrain(actionButton, [
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            actionButton.widthAnchor.constraint(equalToConstant: 28),
            actionButton.heightAnchor.constraint(equalToConstant: toggle.frame.height)
            ])

        constrain(toggle, [
            toggle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            toggle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            toggle.heightAnchor.constraint(equalToConstant: toggle.frame.height),
            toggle.widthAnchor.constraint(equalToConstant: toggle.frame.width)
        ])

        constrain(tableContainer, [
            tableContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableContainer.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 5),
            tableContainer.bottomAnchor.constraint(equalTo: toggle.topAnchor, constant: -5)
        ])
    }

    // MARK: - Actions

    @objc func doDesktopPictures(_ sender: Any) {
        NSWorkspace.shared.open(URL(fileURLWithPath: "file:///Library/Desktop Pictures"))
    }

    @objc func doQuit(_ sender: NSButton) {
        appController?.quit()
    }

    @objc func doClose(_ sender: NSButton) {
        appController?.close()
    }

    @objc func doToggle(_ sender: NSSegmentedControl) {
        let goDark = sender.selectedSegment == 1
        let goLight = sender.selectedSegment == 0

        if isDark() && goLight {
            appController?.setAppearance(.light)
        } else if isLight() && goDark {
            appController?.setAppearance(.dark)
        }
    }

}
