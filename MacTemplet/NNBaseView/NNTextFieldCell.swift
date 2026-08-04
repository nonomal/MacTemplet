//
//  NNTextFieldCell.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/18.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objcMembers
class NNTextFieldCell: NSTextFieldCell {

    var isTextAlignmentVerticalCenter = false

    override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
        super.edit(withFrame: adjustedFrameToVerticallyCenterText(rect), in: controlView, editor: textObj, delegate: delegate, event: event)
    }

    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        super.select(withFrame: adjustedFrameToVerticallyCenterText(rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }

    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.drawInterior(withFrame: adjustedFrameToVerticallyCenterText(cellFrame), in: controlView)
    }

    func adjustedFrameToVerticallyCenterText(_ frame: NSRect) -> NSRect {
        guard isTextAlignmentVerticalCenter, let font = font else {
            return frame
        }
        let offset = floor(NSHeight(frame) / 2 - (font.ascender + font.descender))
        return NSInsetRect(frame, 0.0, offset)
    }
}
