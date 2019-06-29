//
//  AppDelegate.swift
//  Fickle
//
//  Created by Keith Irwin on 4/6/19.
//  Copyright © 2019 Zentrope. All rights reserved.
//

import Cocoa

import os.log

fileprivate let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "AppDelegate")

//@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {

    private var statusBar = NSStatusBar.system
    private var statusBarItem = NSStatusItem()
    private var popover: NSPopover?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.image = NSImage(named: NSImage.actionTemplateName)
        statusBarItem.button?.target = self
        statusBarItem.button?.action = #selector(showThemes(_:))

        let controller = ThemeViewController()
        let p = NSPopover()
        p.delegate = self
        p.contentViewController = controller
        p.behavior = .applicationDefined
        p.contentSize = NSMakeSize(200, 600)
        p.animates = true

        popover = p
    }

    @objc func showThemes(_ sender: NSStatusBarButton) {

        guard let popover = popover else {
            fatalError("Unable to find window.")
        }

        if popover.isShown {
            popover.close()
        } else {
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
        }
    }

    // MARK: NSPopoverDelegate

    func popoverDidDetach(_ popover: NSPopover) {
        if let vc = popover.contentViewController as? ThemeViewController {
            vc.setDetachedAppearance()
        }
    }

    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return true
    }
}
