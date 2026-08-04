//
//  HHLabel.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/20.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

/// 类似 iOS 中的 UILabel（`NNTextField` 子类）。
@objcMembers
class HHLabel: NNTextField {

    var mouseDownBlock: ((HHLabel) -> Void)?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupLabelUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabelUI()
    }

    private func setupLabelUI() {
        autoresizingMask = [.width, .height]
        isBordered = false
        isEditable = false
        drawsBackground = true
        backgroundColor = .clear

        font = NSFont.systemFont(ofSize: 15)
        textColor = .black
        maximumNumberOfLines = 1
        usesSingleLineMode = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    override func mouseDown(with event: NSEvent) {
        mouseDownBlock?(self)
    }
}
