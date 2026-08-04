//
//  AAButton.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/3/21.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import Cocoa

@objcMembers
class AAButton: NSButton {

    /// 背景色 - 默认是 APP 的蓝色按钮
    var backgroundColor: NSColor = .white {
        didSet { needsDisplay = true }
    }

    /// 阴影偏移量 - 如果不需要阴影请不要设置
    var shadowOffset: CGSize = .zero {
        didSet { needsDisplay = true }
    }

    /// 圆角的半径 - 默认为 4
    var cornerRadius: CGFloat = 4 {
        didSet { needsDisplay = true }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .white
        shadowOffset = .zero
        cornerRadius = 4
    }

    /// 设置标题快捷方法
    @objc(setTitle:color:font:)
    func setTitle(_ title: String, color: NSColor, font fontsize: CGFloat) {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .center

        let attDic: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paraStyle,
            .foregroundColor: color,
            .font: NSFont.systemFont(ofSize: fontsize),
        ]
        attributedTitle = NSMutableAttributedString(string: title, attributes: attDic)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    override var wantsUpdateLayer: Bool {
        return true
    }

    override func updateLayer() {
        // changed to the width or height of a single source pixel centered at the specified location.
        layer?.contentsCenter = CGRect(x: 0.5, y: 0.5, width: 0, height: 0)
        layer?.backgroundColor = backgroundColor.cgColor
        layer?.cornerRadius = cornerRadius
        if shadowOffset != .zero {
            layer?.masksToBounds = false
            layer?.shadowColor = backgroundColor.cgColor
            layer?.shadowOffset = CGSize(width: 1, height: 2)
            layer?.shadowRadius = 5
            layer?.shadowOpacity = 1
        }
    }
}
