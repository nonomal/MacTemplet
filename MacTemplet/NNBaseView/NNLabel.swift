//
//  NNLabel.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/3/26.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import Cocoa

@objc enum NSContentVerticalAlignment: Int {
    case top = 0
    case center = 1
    case bottom = 2
}

@objcMembers
class NNLabel: NSView {

    var text: String?
    var font: NSFont?
    var textColor: NSColor?
    var textAlignment: NSTextAlignment = .left
    var contentVerticalAlignment: NSContentVerticalAlignment = .top
    var lineBreakMode: NSLineBreakMode = .byWordWrapping
    var attributedText: NSAttributedString?
    var highlightedTextColor: NSColor?
    var isHighlighted: Bool = false
    var isUserInteractionEnabled: Bool = false
    var isEnabled: Bool = true
    var mouseDownBlock: ((NNLabel) -> Void)?

    override var isFlipped: Bool {
        return true
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        isEnabled = true
        isUserInteractionEnabled = false
        wantsLayer = true
        font = NSFont.systemFont(ofSize: 13, weight: .light)
        textColor = NSColor.labelColor
        textAlignment = .left
        lineBreakMode = .byWordWrapping
        contentVerticalAlignment = .top
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let padding: CGFloat = 8.0
        if isEnabled == false {
            guard let text = text else { return }
            drawString(text, textColor: NSColor.lightGray, padding: padding)
            return
        }

        if let attributedText = attributedText {
            drawAttributedString(attributedText, padding: padding)
        } else {
            guard let text = text else { return }
            let drawColor = isHighlighted ? (highlightedTextColor ?? self.textColor) : self.textColor
            drawString(text, textColor: drawColor ?? NSColor.labelColor, padding: padding)
        }
    }

    override func mouseDown(with event: NSEvent) {
        mouseDownBlock?(self)
    }

    func actionBlock(_ block: @escaping (NNLabel) -> Void) {
        if isUserInteractionEnabled == false {
            return
        }
        mouseDownBlock = block
    }

    private func drawAttributedString(_ attributedString: NSAttributedString, padding: CGFloat) {
        let maxSize = CGSize(width: bounds.size.width - padding * 2, height: CGFloat.greatestFiniteMagnitude)
        let size = attributedString.boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size

        var gapX = padding + (maxSize.width - size.width) / 2
        var gapY = (bounds.height - size.height) / 2

        switch contentVerticalAlignment {
        case .center:
            break
        case .bottom:
            gapY *= 2
        default:
            gapY = 0
        }

        if textAlignment == .left {
            gapX = size.width < maxSize.width ? 0 : gapX
        } else if textAlignment == .right {
            gapX = size.width < maxSize.width ? gapX * 2 : 0
        }

        let contentRect = NSRect(
            x: floor(gapX),
            y: floor(gapY),
            width: size.width,
            height: size.height
        )
        attributedString.draw(in: contentRect)
    }

    private func drawString(_ string: String, textColor: NSColor, padding: CGFloat) {
        let paraStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paraStyle.alignment = textAlignment
        paraStyle.lineBreakMode = lineBreakMode

        let attrDic: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paraStyle,
            .foregroundColor: textColor,
            .font: font as Any
        ]

        let attString = NSAttributedString(string: string, attributes: attrDic)
        drawAttributedString(attString, padding: padding)
    }
}
