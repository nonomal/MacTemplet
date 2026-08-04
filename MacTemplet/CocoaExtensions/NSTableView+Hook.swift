//
//  NSTableView+Hook.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/12.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

// Hook implementation is commented out in the original ObjC port.
// Preserved for reference; no install() required.

extension NSTableView {

//    static func install() {
//        SwizzleInstanceMethod(NSTableView.self, #selector(NSTableView.init), #selector(NSTableView.hook_init))
//    }
//
//    @objc func hook_init() {
//        hook_init()
//
//        let scrollView = NSView.createScrollViewRect(.zero)
//        scrollView.documentView = self
//        DDLog("\(self)_\(String(describing: scrollView.documentView))_\(scrollView)")
//    }

//    @objc var scrollView: NSScrollView {
//        if let obj = objc_getAssociatedObject(self, #selector(getter: scrollView)) as? NSScrollView {
//            return obj
//        }
//        let obj = NSView.createScrollViewRect(.zero)
//        objc_setAssociatedObject(self, #selector(getter: scrollView), obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        return obj
//    }
//
//    @objc func setScrollView(_ scrollView: NSScrollView) {
//        objc_setAssociatedObject(self, #selector(getter: scrollView), scrollView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//    }
}
