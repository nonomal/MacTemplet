//
//  AppDelegate.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/8.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SwiftExpand

@objcMembers
class AppDelegate: NSObject, NSApplicationDelegate {

    private static let hooksBootstrap: Void = {
        CocoaHooks.install()
    }()

    override init() {
        super.init()
        _ = AppDelegate.hooksBootstrap
    }

    lazy var window: NSWindow = {
        let screen = NSScreen.main ?? NSScreen.screens.first
        let screenFrame = screen?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1280, height: 800)
        let size = CGSize(width: max(screenFrame.width * 0.6, 900),
                          height: max(screenFrame.height * 0.6, 600))
        let style: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
        let window = NSWindow(contentRect: NSRect(origin: .zero, size: size),
                              styleMask: style,
                              backing: .buffered,
                              defer: false)
        window.isReleasedWhenClosed = false
        // Min size must stay below initial content size (0.65 > 0.6 previously hid / clamped the window).
        window.contentMinSize = CGSize(width: 720, height: 480)
        window.title = "App代码助手"
        window.titlebarAppearsTransparent = false
        window.isOpaque = true
        window.backgroundColor = .windowBackgroundColor
        window.collectionBehavior = [.fullScreenPrimary, .managed]
        window.center()
        return window
    }()

    lazy var windowCtrl: NSWindowController = {
        NSWindowController(window: window)
    }()

    lazy var popover: NSPopover = {
        let controller = FirstViewController()
        controller.view.frame = CGRect(x: 0, y: 0, width: 320, height: 200)
        return NSPopover(vc: controller)
    }()

    var statusItem: NSStatusItem?

    lazy var dockMenu: NSMenu = {
        let oneItem = NSMenuItem(title: "新的Dock目录", action: nil, keyEquivalent: "P")
        let subMenu = NSMenu(title: "一级目录")
        subMenu.addItem(withTitle: "Load1", keyEquivalent: "E") { menuItem in
            DDLog("\(menuItem.title)_\(menuItem.keyEquivalent)")
        }
        subMenu.addItem(withTitle: "Load2", keyEquivalent: "E") { menuItem in
            DDLog("\(menuItem.title)_\(menuItem.keyEquivalent)")
        }
        oneItem.submenu = subMenu

        let menu = NSMenu(title: "DockMenu")
        menu.autoenablesItems = false
        menu.addItem(oneItem)
        return menu
    }()

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        true
    }

    func applicationWillFinishLaunching(_ notification: Notification) {
        _ = AppDelegate.hooksBootstrap
        CocoaHooks.install()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserDefaults.standard.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
        UserDefaults.standard.set(true, forKey: "LAYOUT_CONSTRAINTS_NOT_SATISFIABLE")
        UserDefaults.standard.set(0, forKey: "NSInitialToolTipDelay")

        window.contentViewController = HomeViewController()
        windowCtrl.showWindow(self)
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mainWindowWillClose(_:)),
                                               name: NSWindow.willCloseNotification,
                                               object: window)

        AppDelegate.setupMainMenu()
        if statusItem == nil {
            statusItem = AppDelegate.setupStatusItem()
            statusItem?.button?.addActionHandler { [weak self] control in
                guard let self = self, let sender = control as? NSButton else { return }
                self.popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
            }
            statusItem?.button?.resignFirstResponder()
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    @objc func mainWindowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        UserDefaults.standard.set(NSStringFromRect(window.frame), forKey: kMainWindowFrame)
        UserDefaults.standard.synchronize()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: nil)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            NSApp.activate(ignoringOtherApps: true)
            windowCtrl.showWindow(self)
            window.makeKeyAndOrderFront(self)
            return true
        }
        return false
    }

    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        dockMenu
    }
}

// MARK: - Menu

extension AppDelegate {

    @objc static func setupMainMenu() {
        let mainMenu = NSMenu(title: "mainMenu")

        let appMenuItem = NSMenuItem()
        let appMenu = NSMenu()
        appMenu.addItem(withTitle: "Quit \(NSApplication.appName ?? "MacTemplet")",
                        action: #selector(NSApplication.terminate(_:)),
                        keyEquivalent: "q")
        appMenuItem.submenu = appMenu
        mainMenu.addItem(appMenuItem)

        let oneItem = NSMenuItem(title: "一级目录", action: nil, keyEquivalent: "O")
        oneItem.submenu = {
            let menu = NSMenu(title: "二级目录")
            menu.addItem(withTitle: "Load1", keyEquivalent: "E") { menuItem in
                DDLog("\(menuItem.title)_\(menuItem.keyEquivalent)")
            }
            menu.addItem(withTitle: "Load2", keyEquivalent: "T") { menuItem in
                DDLog("\(menuItem.title)_\(menuItem.keyEquivalent)")
            }
            return menu
        }()

        let oneItem3 = NSMenuItem(title: "Load3", keyEquivalent: "T") { item in
            DDLog("\(item.title)_\(item.keyEquivalent)")
        }
        oneItem3.submenu = {
            let menu = NSMenu(title: "三级目录")
            menu.addItem(withTitle: "-30", keyEquivalent: "T") { menuItem in
                DDLog("\(menuItem.title)_\(menuItem.keyEquivalent)")
            }
            menu.addItem(withTitle: "-31", keyEquivalent: "T") { menuItem in
                DDLog("\(menuItem.title)_\(menuItem.keyEquivalent)")
            }
            return menu
        }()

        let twoItem = NSMenuItem(title: "一级目录", action: nil, keyEquivalent: "O")
        twoItem.submenu = {
            let menu = NSMenu(title: "二级目录")
            menu.addItem(withTitle: "1000", keyEquivalent: "E") { menuItem in
                DDLog("\(menuItem.title)_\(menuItem.keyEquivalent)")
            }
            menu.addItem(withTitle: "1001", keyEquivalent: "T") { menuItem in
                DDLog("\(menuItem.title)_\(menuItem.keyEquivalent)")
            }
            return menu
        }()

        let threeItem = NSMenuItem(title: "一级目录", action: nil, keyEquivalent: "O")
        threeItem.submenu = {
            let menu = NSMenu(title: "二级目录")
            menu.addItem(withTitle: "2000", keyEquivalent: "E") { menuItem in
                DDLog("\(menuItem.title)_\(menuItem.keyEquivalent)")
            }
            menu.addItem(withTitle: "2001", keyEquivalent: "T") { menuItem in
                DDLog("\(menuItem.title)_\(menuItem.keyEquivalent)")
            }
            return menu
        }()

        oneItem.submenu?.addItem(oneItem3)
        mainMenu.addItem(oneItem)
        mainMenu.addItem(twoItem)
        mainMenu.addItem(threeItem)
        NSApp.mainMenu = mainMenu
    }

    @objc static func setupStatusItem() -> NSStatusItem {
        NSStatusItem.create(imageName: nil)
    }
}
