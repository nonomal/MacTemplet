//
//  NSTableCellViewTen.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/25.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftExpand

@objcMembers
class NSTableCellViewTen: NSTableCellView {

    lazy var checkBox: NSButton = {
        let view = NSButton(checkboxWithTitle: "构造函数", target: nil, action: nil)
        view.addActionHandler { _ in
        }
        return view
    }()

    lazy var textLabel: HHLabel = {
        let view = HHLabel(frame: .zero)
        view.font = NSFont.systemFont(ofSize: 13)
        view.alignment = .right
        view.isBordered = false
        view.backgroundColor = NSColor.clear.withAlphaComponent(0)
        view.stringValue = String(describing: type(of: self))
        return view
    }()

    lazy var textView: NNTextView = {
        let view = NNTextView.create(.zero)
        view.font = NSFont.systemFont(ofSize: 12)
        view.layer?.borderWidth = 1
        view.layer?.borderColor = NSColor.lightGray.cgColor
        return view
    }()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        addSubview(checkBox)
        addSubview(textLabel)
        addSubview(textView.enclosingScrollView!)
        addSubview(lineBottom)
    }

    override func layout() {
        super.layout()

        guard bounds.size.height > 0 else { return }

        let checkBoxSize = checkBox.sizeThatFits(NSSize(width: 100, height: 30))
        guard bounds.height > checkBoxSize.height else { return }

        checkBox.snp.makeConstraints { make in
            make.top.equalTo(self).offset(kX_GAP)
            make.left.equalTo(self).offset(0)
            make.width.equalTo(checkBoxSize.width)
            make.height.lessThanOrEqualTo(checkBoxSize.height)
        }

        let textLabelSize = textLabel.sizeThatFits(NSSize(width: 180, height: 30))
        textLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkBox)
            make.right.equalTo(self).offset(-15)
            make.width.equalTo(180)
            make.height.lessThanOrEqualTo(textLabelSize.height)
        }

        textView.enclosingScrollView!.snp.makeConstraints { make in
            make.top.equalTo(checkBox.snp.bottom).offset(kPadding)
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.bottom.equalTo(self)
        }

        lineBottom.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(textView.snp.top)
            make.height.equalTo(0.35)
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
}
