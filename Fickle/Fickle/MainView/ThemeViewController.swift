//
//  ThemeViewController.swift
//  Fickle
//
//  Created by Keith Irwin on 4/6/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa
import os.log

fileprivate let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "ThemeViewController")

class ThemeViewController: NSViewController {

    private var themeTableView = ThemeTableView()
    private var controlBar = ThemeControlBar()

    private var topMarginContraint: NSLayoutConstraint?

    override func loadView() {
        let view = NSView(frame: NSMakeRect(0, 0, 200, 600))

        themeTableView.translatesAutoresizingMaskIntoConstraints = false

        controlBar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(themeTableView)
        view.addSubview(controlBar)

        topMarginContraint = themeTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)

        NSLayoutConstraint.activate([
            controlBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controlBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            themeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            themeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topMarginContraint!,
            themeTableView.bottomAnchor.constraint(equalTo: controlBar.topAnchor, constant: -5)
            ])

        view.wantsLayer = true
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Storage.load() { themes in
            DispatchQueue.main.async {
                self.themeTableView.setData(themes)
            }
        }

        controlBar.action = { event in
            switch event {

            case .goLight:
                ScriptManager.sendAppearanceScript(.light)

            case .goDark:
                ScriptManager.sendAppearanceScript(.dark)

            case .showDesktopPix:
                NSWorkspace.shared.open(URL(fileURLWithPath: "file:///Library/Desktop Pictures"))

            case .quit:
                NSApp.activate(ignoringOtherApps: true)
                NSApp.terminate(self)
            }
        }

        themeTableView.action = { [weak self] event in
            switch event {

            case .delete(let themes, let index):
                self?.delete(from: themes, at: index)

            case .select(let theme):
                self?.select(theme: theme)

            case .reveal(let theme):
                self?.reveal(theme: theme)
            }
        }

        NotificationCenter.default.addObserver(forName: .applicationThemeWasUpdated, object: nil, queue: OperationQueue.main) { [weak self] _ in
            if let data = self?.themeTableView.data {
                Storage.save(data)
            }
        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        topMarginContraint?.constant = 8
    }

    func setDetachedAppearance() {
        NSAnimationContext.runAnimationGroup { (ctx) in
            ctx.duration = 0.05
            topMarginContraint?.animator().constant = 24
        }
    }

    private func delete(from themes: [Theme], at index: Int) {
        var data = themes
        data.remove(at: index)
        Storage.save(data)
    }

    private func select(theme: Theme) {
        guard let screen = NSScreen.main else { return }
        guard let options = NSWorkspace.shared.desktopImageOptions(for: screen) else { return }

        do {
            // NOTE: Setting options myself always dumps a stack trace.
            try NSWorkspace.shared.setDesktopImageURL(theme.backgroundImageURL, for: screen, options: options)
            ScriptManager.sendAppearanceScript(theme.appearance == .light ? .light : .dark)
        }
        catch let error {
            os_log("%{public}s", log: logger, type: .error, error.localizedDescription)
        }
    }

    private func reveal(theme: Theme) {
        ScriptManager.sendShowInFinderTemplate(theme.backgroundImageURL)
    }
}
