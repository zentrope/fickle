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
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBar = NSStatusBar.system
    var statusBarItem = NSStatusItem()

    var window: NSWindow?
    var controller: ViewController?

    var appController = AppController()

    // MARK: - Lifecycle

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        os_log("%{public}s", log: logger, "initializing application")
        setupMenu()
        setupWindow()
        setupStatusItem()
        os_log("%{public}s", log: logger, "application launched")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        os_log("%{public}s", log: logger, "application will terminate")
    }

    // MARK: - Setup

    private func setupWindow() {
        let width: CGFloat = 204
        let size = NSMakeRect(0, 0, width, 600)
        let mask: NSWindow.StyleMask = [.resizable, .fullSizeContentView, .titled]
        let window = NSWindow(contentRect: size, styleMask: mask, backing: .buffered, defer: false)

        window.isReleasedWhenClosed = false // So we can .close
        window.isMovableByWindowBackground = true
        window.titleVisibility = NSWindow.TitleVisibility.hidden
        window.titlebarAppearsTransparent = true
        window.showsToolbarButton = false
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.hasShadow = true
        window.minSize = NSMakeSize(width, 450)
        window.maxSize = NSMakeSize(width, 600)
        window.isOpaque = false

        controller = ViewController()
        controller?.appController = appController

        let content = window.contentView! as NSView
        let view = controller?.view
        content.addSubview(view!)

        window.contentViewController = controller

        appController.mainWindow = window
        self.window = window
    }

    private func setupStatusItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        statusBarItem.button?.image = NSImage(named: NSImage.actionTemplateName)
        statusBarItem.button?.target = self
        statusBarItem.button?.action = #selector(buttonClicked(_:))
    }

    private func setupMenu() {
        let mainMenu = NSMenu()
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        let appMenu = NSMenu()
        let appName = ProcessInfo.processInfo.processName
        appMenu.addItem(withTitle: "Quit \(appName)", action: #selector(quitApp(_:)), keyEquivalent: "q")
        appMenuItem.submenu = appMenu
        NSApp.mainMenu = mainMenu
    }

    // MARK: - Actions

    @objc func quitApp(_ sender: Any) {
        os_log("%{public}s", log: logger, "app quit requested")
        NSApp.terminate(sender)
    }

    @objc func buttonClicked(_ sender: NSStatusBarButton) {

        guard let window = window else {
            os_log("%{public}s", log: logger, type: .error, "unable to load window")
            return
        }

        if window.isVisible {
            window.orderOut(nil)
            return
        }

        let loc = NSEvent.mouseLocation
        let newLoc = NSMakePoint(loc.x - 102, loc.y)
        window.setFrameTopLeftPoint(newLoc)
        window.makeKeyAndOrderFront(nil)
        window.level = .statusBar
    }

}
