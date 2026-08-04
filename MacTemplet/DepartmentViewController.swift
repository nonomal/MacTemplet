//
//  DepartmentViewController.swift
//  Swift-NSToolBar
//
//  Created by Debasis Das on 5/2/15.
//  Copyright (c) 2015 Knowstack. All rights reserved.
//

import Cocoa
import SwiftExpand

class DepartmentViewController: NSViewController {
    override func loadView() {
        // 设置 ViewController 大小同 mainWindow
        let windowRect = NSApplication.shared.mainWindow?.frame
            ?? NSRect(x: 0, y: 0, width: NSScreen.main!.frame.width * 0.4, height: NSScreen.main!.frame.height * 0.4)
        view = NSView(frame: windowRect)
        view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.layer?.backgroundColor = NSColor.lightBlue.cgColor
        
        preferredContentSize = CGSize(width: NSScreen.main!.frame.width*0.4, height: NSScreen.main!.frame.height*0.4)

    }
    
}


class AccountViewController: NSViewController {
    override func loadView() {
        // 设置 ViewController 大小同 mainWindow
        let windowRect = NSApplication.shared.mainWindow?.frame
            ?? NSRect(x: 0, y: 0, width: NSScreen.main!.frame.width * 0.5, height: NSScreen.main!.frame.height * 0.5)
        view = NSView(frame: windowRect)
        view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        view.layer?.backgroundColor = NSColor.lightGreen.cgColor
        
        preferredContentSize = CGSize(width: NSScreen.main!.frame.width*0.5, height: NSScreen.main!.frame.height*0.5)
    }
    
}

class EmployeeViewController: NSViewController {
    override func loadView() {
        // 设置 ViewController 大小同 mainWindow
        let windowRect = NSApplication.shared.mainWindow?.frame
            ?? NSRect(x: 0, y: 0, width: NSScreen.main!.frame.width * 0.6, height: NSScreen.main!.frame.height * 0.6)
        view = NSView(frame: windowRect)
        view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        view.layer?.backgroundColor = NSColor.lightOrange.cgColor
        
        preferredContentSize = CGSize(width: NSScreen.main!.frame.width*0.6, height: NSScreen.main!.frame.height*0.6)

    }
    
}
