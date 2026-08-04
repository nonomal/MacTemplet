//
//  main.swift
//  MacTemplet
//
//  Explicit AppKit entry — ensures AppDelegate is attached as NSApp.delegate.
//

import AppKit

autoreleasepool {
    let app = NSApplication.shared
    // Required for programmatic entry (no MainMenu nib / NSApplicationMain defaults).
    app.setActivationPolicy(.regular)
    let delegate = AppDelegate()
    app.delegate = delegate
    app.run()
}
