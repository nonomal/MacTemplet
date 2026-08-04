//
//  NSCTViewItemOne.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/18.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objcMembers
class NSCTViewItemOne: NSView {

    var isSelected = false {
        didSet {
            needsDisplay = true
        }
    }

    var highlightState: NSCollectionViewItem.HighlightState = .none

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
}
