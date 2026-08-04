//
//  NNTableRowView.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/18.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objcMembers
class NNTableRowView: NSTableRowView {

    var fillColor: NSColor?
    var strokeColor: NSColor?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    override func drawSelection(in dirtyRect: NSRect) {
        let selectionRect = bounds.insetBy(dx: 0, dy: 0)
        NSColor(calibratedWhite: 0.82, alpha: 1.0).setFill()
        NSColor(calibratedWhite: 0.82, alpha: 1.0).setStroke()
        strokeColor?.setStroke()
        fillColor?.setFill()

        let selectionPath = NSBezierPath(roundedRect: selectionRect, xRadius: 0, yRadius: 0)
        selectionPath.lineWidth = 1.5
        selectionPath.fill()
        selectionPath.stroke()
    }

    override func drawBackground(in dirtyRect: NSRect) {
        super.drawBackground(in: dirtyRect)
        NSColor.white.setFill()
        dirtyRect.fill()
    }
}
