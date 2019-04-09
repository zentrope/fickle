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

class ViewController: NSViewController {

    // MARK: - Controls

    private lazy var toggle: NSSegmentedControl = {
        let control = NSSegmentedControl()
        control.segmentCount = 2
        control.setLabel("Light", forSegment: 0)
        control.setLabel("Dark", forSegment: 1)
        control.trackingMode = .selectOne
        control.target = self
        control.action = #selector(onAppearanceToggle(_:))
        control.segmentStyle = NSSegmentedControl.Style.roundRect
        control.segmentDistribution = NSSegmentedControl.Distribution.fit
        control.sizeToFit()
        return control
    }()

    private lazy var dismissButton: NSButton = {
        let button = NSButton()
        button.bezelStyle = .texturedSquare
        button.isBordered = false
        button.target = self
        button.action = #selector(onCloseButton(_:))
        button.image = NSImage(named: NSImage.stopProgressFreestandingTemplateName)
        button.setButtonType(NSButton.ButtonType.momentaryPushIn)
        button.isEnabled = true
        return button
    }()

    private lazy var quitButton: NSButton = {
        let button = NSButton()
        button.bezelStyle = NSButton.BezelStyle.roundRect
        button.target = self
        button.action = #selector(onQuit(_:))
        button.title = "Quit"
        button.isEnabled = true
        button.sizeToFit()
        return button
    }()

    private var tableContainer = MainTableView()

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

        setupToggle()
        setupLayout()
        setupAppearanceObserver()
    }


    override func viewDidAppear() {
        super.viewDidAppear()
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
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

    private func setupToggle() {
        toggle.selectedSegment = isDark() ? 1 : 0
    }

    private func setupLayout() {
        view.addSubview(dismissButton)
        view.addSubview(quitButton)
        view.addSubview(toggle)
        view.addSubview(tableContainer)

        let constrain = { (field: NSView, constraints: [NSLayoutConstraint]) in
            field.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(constraints)
        }

        constrain(dismissButton, [
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 9),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            dismissButton.widthAnchor.constraint(equalToConstant: 19)
            ])

        constrain(quitButton, [
            quitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            quitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            quitButton.widthAnchor.constraint(equalToConstant: quitButton.frame.width),
            quitButton.heightAnchor.constraint(equalToConstant: quitButton.frame.height)
            ])

        constrain(toggle, [
            toggle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            toggle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            toggle.heightAnchor.constraint(equalToConstant: toggle.frame.height),
            toggle.widthAnchor.constraint(equalToConstant: toggle.frame.width)
        ])

        constrain(tableContainer, [
            tableContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableContainer.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 10),
            tableContainer.bottomAnchor.constraint(equalTo: toggle.topAnchor, constant: -10)
        ])
    }

    // MARK: - Actions

    @objc func onQuit(_ sender: NSButton) {
        appController?.quit()
    }

    @objc func onCloseButton(_ sender: NSButton) {
        appController?.close()
    }

    @objc func onAppearanceToggle(_ sender: NSSegmentedControl) {
        let goDark = sender.selectedSegment == 1
        let goLight = sender.selectedSegment == 0

        if isDark() && goLight {
            appController?.setAppearance(.light)
        } else if isLight() && goDark {
            appController?.setAppearance(.dark)
        }
    }

}
