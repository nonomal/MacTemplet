//
//  NNTextView.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/20.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objcMembers
class NNTextView: NSTextView {

    var placeHolder: String?

    lazy var scrollView: NSScrollView = {
        let view = NSScrollView()
        view.backgroundColor = .white
        view.drawsBackground = false
        view.hasHorizontalScroller = false
        view.hasVerticalScroller = true
        view.autohidesScrollers = true
        return view
    }()

    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
        setupUI()
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        scrollView.documentView = self
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        if string.isEmpty, self != window?.firstResponder, let placeHolder = placeHolder {
            let attDic: [NSAttributedString.Key: Any] = [.foregroundColor: NSColor.gray]
            let attString = NSAttributedString(string: placeHolder, attributes: attDic)
            attString.draw(at: NSPoint(x: 4, y: 0))
        }
    }

    override func resignFirstResponder() -> Bool {
        needsDisplay = true
        return super.resignFirstResponder()
    }
}
