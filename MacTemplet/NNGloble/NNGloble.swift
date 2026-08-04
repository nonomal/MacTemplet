//
//  NNGloble.swift
//  MacTemplet
//
//  Replaces NNGloble.h / NNMarco.h / NNShared.h.
//  DDLog / kScreenWidth / kSizeArrow live in SwiftExpand.
//

import Cocoa

typealias BlockCellForRow = (NSTableView, IndexPath) -> NSTableCellView
typealias BlockDidSelectRow = (NSTableView, IndexPath) -> Void

@inline(__always)
func dispatch_main_sync_safe(_ block: () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync(execute: block)
    }
}

@inline(__always)
func dispatch_main_async_safe(_ block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}
