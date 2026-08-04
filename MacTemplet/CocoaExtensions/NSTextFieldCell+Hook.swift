//
//  NSTextFieldCell+Hook.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/18.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

// Hook implementation is commented out in the original ObjC port.
// Preserved for reference; no install() required.

extension NSTextFieldCell {

//    static func install() {
//        SwizzleInstanceMethod(NSTextFieldCell.self,
//                              NSSelectorFromString("editWithFrame:editor:delegate:event:"),
//                              #selector(NSTextFieldCell.hook_editWithFrame(_:inView:editor:delegate:event:)))
//        SwizzleInstanceMethod(NSTextFieldCell.self,
//                              #selector(NSTextFieldCell.select(withFrame:in:editor:delegate:start:length:)),
//                              #selector(NSTextFieldCell.hook_selectWithFrame(_:inView:editor:delegate:start:length:)))
//        SwizzleInstanceMethod(NSTextFieldCell.self,
//                              #selector(NSTextFieldCell.drawInterior(withFrame:in:)),
//                              #selector(NSTextFieldCell.hook_drawInteriorWithFrame(_:inView:)))
//    }
//
//    @objc var isTextAlignmentVerticalCenter: Bool {
//        get { (objc_getAssociatedObject(self, #selector(getter: isTextAlignmentVerticalCenter)) as? Bool) ?? false }
//        set { objc_setAssociatedObject(self, #selector(getter: isTextAlignmentVerticalCenter), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
//    }
//
//    func adjustedFrameToVerticallyCenterText(_ frame: NSRect) -> NSRect {
//        if !isTextAlignmentVerticalCenter { return frame }
//        let offset = floor((frame.height / 2) - (font!.ascender + font!.descender))
//        return frame.insetBy(dx: 0, dy: offset)
//    }
//
//    @objc func hook_editWithFrame(_ aRect: NSRect, inView controlView: NSView, editor: NSText, delegate: Any?, event: NSEvent?) {
//        super.edit(withFrame: adjustedFrameToVerticallyCenterText(aRect), in: controlView, editor: editor, delegate: delegate, event: event)
//    }
//
//    @objc func hook_selectWithFrame(_ aRect: NSRect, inView controlView: NSView, editor: NSText, delegate: Any?, start: Int, length: Int) {
//        super.select(withFrame: adjustedFrameToVerticallyCenterText(aRect), in: controlView, editor: editor, delegate: delegate, start: start, length: length)
//    }
//
//    @objc func hook_drawInteriorWithFrame(_ frame: NSRect, inView view: NSView) {
//        super.drawInterior(withFrame: adjustedFrameToVerticallyCenterText(frame), in: view)
//    }
}
