//
//  MainViewController.swift
//  Fickle
//
//  Created by Keith Irwin on 4/6/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa
import os.log

fileprivate let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "MainViewController")

class MainViewController: NSViewController {

    // MARK: - Controls

    lazy var toggle: NSSegmentedControl = {
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

    lazy var dismissButton: NSButton = {
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

    lazy var quitButton: NSButton = {
        let button = NSButton()
        button.bezelStyle = NSButton.BezelStyle.roundRect
        button.target = self
        button.action = #selector(onQuit(_:))
        button.title = "Quit"
        button.isEnabled = true
        button.sizeToFit()
        return button
    }()

    var tableContainer = MainTableView()

    // MARK: - Coordinator
    var coordinator: Coordinator?

    // MARK: - Lifecycle

    override func loadView() {
        let view = NSView(frame: NSMakeRect(0, 0, 400, 600))
        view.wantsLayer = true
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        toggle.selectedSegment = (coordinator?.isDark())! ? 1 : 0

        setupLayout()
        setupTableView()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
    }

    // MARK: - Implementation

    private func setupTableView() {
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

    @objc func onQuit(_ sender: Any) {
        os_log("%{public}s", log: logger, "button quit")
        coordinator?.quit()
    }

    @objc func onCloseButton(_ sender: Any?) {
        self.view.window?.orderOut(self)
    }

    @objc func onAppearanceToggle(_ sender: NSSegmentedControl) {

        guard let coordinator = coordinator else {
            return
        }

        switch sender.selectedSegment {
        case 0:
            if !coordinator.setAppearance(.light) {
                sender.selectedSegment = 1
            }
        case 1:
            if !coordinator.setAppearance(.dark) {
                sender.selectedSegment = 0
            }
        default:
            os_log("%{public}s", log: logger, type: .error, "unable to respond to appearance toggle")
        }
    }

}
