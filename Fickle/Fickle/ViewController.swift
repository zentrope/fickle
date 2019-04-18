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
    private var themeList      = ImageListView()
    private var actionButton   = ActionMenuButton()

    // MARK: - AppController

    var appController: AppController?

    // MARK: - Lifecycle

    override func loadView() {
        let view = NSView(frame: NSMakeRect(0, 0, 200, 600))
        view.wantsLayer = true
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        toggle.target = self
        toggle.action = #selector(doToggle(_:))

        setupToggle()
        setupLayout()
        setupAppearanceObserver()
        setupActionMenu()

        themeList.delegate = appController
        themeList.tableDelegate = appController
        themeList.tableDataSource = appController

        themeList.reload()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        topper?.constant = 8
    }

    // MARK: - Public functions

    func setDetached() {
        NSAnimationContext.runAnimationGroup { (ctx) in
            ctx.duration = 0.05
            topper?.animator().constant = 24
        }
    }

    // MARK: - Implementation

    private var observer: NSKeyValueObservation?

    private func setupAppearanceObserver() {
        observer = view.observe(\.effectiveAppearance) { (_, _) in
            self.setupToggle()
        }
    }

    private func isDark() -> Bool {
        return view.effectiveAppearance.bestMatch(from: [.darkAqua]) == .darkAqua
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

    var topper: NSLayoutConstraint?

    private func setupLayout() {
        view.addSubview(toggle)
        view.addSubview(themeList)
        view.addSubview(actionButton)

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

        topper = themeList.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
        constrain(themeList, [
            themeList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            themeList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topper!,
            themeList.bottomAnchor.constraint(equalTo: toggle.topAnchor, constant: -5)
        ])
    }

    // MARK: - Actions

    @objc func doDesktopPictures(_ sender: Any) {
        NSWorkspace.shared.open(URL(fileURLWithPath: "file:///Library/Desktop Pictures"))
    }

    @objc func doQuit(_ sender: NSButton) {
        appController?.quit()
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
