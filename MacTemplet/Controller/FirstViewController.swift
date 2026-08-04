//
//  FirstViewController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/11.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SwiftExpand

@objcMembers class FirstViewController: NSViewController {

    private var modalSession: NSApplication.ModalSession?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(segmentCtl)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(windowWillClose(_:)),
                                             name: NSWindow.willCloseNotification,
                                             object: nil)
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        segmentCtl.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
    }

    override func viewWillAppear() {
        super.viewWillAppear()
    }

    func handleActionSender(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case 0:
            windowCtrl.showWindow(nil)
        case 1:
            NSApplication.shared.runModal(for: windowCtrl.window!)
        case 2:
            if let window = windowCtrl.window {
                modalSession = NSApplication.shared.beginModalSession(for: window)
            }
        default:
            break
        }
    }

    @objc func windowWillClose(_ notification: Notification) {
        switch segmentCtl.selectedSegment {
        case 0:
            NSApplication.shared.stopModal()
        case 1:
            NSApplication.shared.stopModal()
        case 2:
            if let modalSession = modalSession {
                NSApplication.shared.endModalSession(modalSession)
            }
        default:
            break
        }
    }

    // MARK: - lazy

    lazy var windowCtrl: NSWindowController = {
        let window = NSWindow(vc: nil, size: NSWindow.defaultSize)
        window.title = "First"
        let contentVC = ListViewController()
        window.contentViewController = contentVC
        return NSWindowController(window: window)
    }()

    lazy var segmentCtl: NSSegmentedControl = {
        let items = ["事件_0", "事件_1", "事件_2"]
        let view = NSSegmentedControl()
        view.items = items
        view.addActionHandler { control in
            guard let sender = control as? NSSegmentedControl else { return }
            self.handleActionSender(sender)
        }
        return view
    }()
}
