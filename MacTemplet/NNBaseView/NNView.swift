//
//  NNView.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/8.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objcMembers
class NNView: NSView {

    var backgroundColor: NSColor? {
        didSet {
            wantsLayer = true
            layer?.backgroundColor = backgroundColor?.cgColor
        }
    }

    override var isFlipped: Bool {
        return true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
}
