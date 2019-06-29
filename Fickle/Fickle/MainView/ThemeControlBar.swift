//
//  ControlBar.swift
//  Fickle
//
//  Created by Keith Irwin on 6/29/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

class ThemeControlBar: NSView {

    enum Event {
        case goLight, goDark, showDesktopPix, quit
    }

    var action: ((Event) -> Void)?

    private var toggle = NSSegmentedControl()
    private var actions = NSPopUpButton()

    convenience init() {
        self.init(frame: .zero)

        let icon = NSMenuItem()
        icon.image = NSImage(named: NSImage.actionTemplateName)
        icon.isHidden = false
        icon.title = "la"

        let quit = NSMenuItem(title: "Quit",
                              action: #selector(invokeQuitMenuItem(_:)),
                              keyEquivalent: "q")

        let desk = NSMenuItem(title: "Reveal Apple Desktop Pictures",
                              action: #selector(invokeShowAppleDesktopPictures(_:)),
                              keyEquivalent: "l")
        desk.target = self
        quit.target = self

        let contextMenu = NSMenu()
        contextMenu.addItem(icon)
        contextMenu.addItem(desk)
        contextMenu.addItem(NSMenuItem.separator())
        contextMenu.addItem(quit)

        actions.menu = contextMenu
        actions.pullsDown = true
        actions.bezelStyle = .roundRect
        actions.isEnabled = true
        actions.preferredEdge = .maxY
        actions.autoenablesItems = true
        actions.isBordered = false
        actions.translatesAutoresizingMaskIntoConstraints = false

        if let cell = actions.cell as? NSPopUpButtonCell {
            cell.arrowPosition = NSPopUpButton.ArrowPosition.noArrow
            cell.usesItemFromMenu = true
            cell.pullsDown = true
        }

        toggle.target = self
        toggle.action = #selector(toggleDarkLightMode(_:))
        toggle.segmentCount = 2
        toggle.setLabel("Light", forSegment: 0)
        toggle.setLabel("Dark", forSegment: 1)
        toggle.trackingMode = .selectOne
        toggle.segmentStyle = .roundRect
        toggle.segmentDistribution = .fit
        toggle.translatesAutoresizingMaskIntoConstraints = false

        addSubview(toggle)
        addSubview(actions)

        NSLayoutConstraint.activate([
            toggle.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            toggle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            toggle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),

            actions.centerYAnchor.constraint(equalTo: toggle.centerYAnchor),
            actions.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            actions.widthAnchor.constraint(equalToConstant: 28),
            actions.heightAnchor.constraint(equalToConstant: 32),
            ])
        updateToggle()
    }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        updateToggle()
    }

    func updateToggle() {
        let isDark = effectiveAppearance.bestMatch(from: [.darkAqua]) == .darkAqua
        toggle.selectedSegment = isDark ? 1 : 0
    }

    @objc func toggleDarkLightMode(_ sender: NSSegmentedControl) {
        let isDark = effectiveAppearance.bestMatch(from: [.darkAqua]) == .darkAqua
        let isLight = !isDark

        let goDark = sender.selectedSegment == 1
        let goLight = sender.selectedSegment == 0

        if isDark && goLight {
            action?(.goLight)
        } else if isLight && goDark {
            action?(.goDark)
        }
    }

    @objc func invokeQuitMenuItem(_ sender: NSMenuItem) {
        action?(.quit)
    }

    @objc func invokeShowAppleDesktopPictures(_ sender: NSMenuItem) {
        action?(.showDesktopPix)
    }
}
