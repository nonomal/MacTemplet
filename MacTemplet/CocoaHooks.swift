//
//  CocoaHooks.swift
//  MacTemplet
//
//  Central registration for Cocoa runtime hooks.
//  NSView / NSViewController / CrashProtector install via ObjC +load/+initialize.
//

import Foundation

@objcMembers
class CocoaHooks: NSObject {

    /// Idempotent. View/VC/CrashProtector hooks self-install in ObjC (+load / +initialize).
    static func install() {
        // Intentionally empty — kept as a stable call site for AppDelegate.
    }
}
