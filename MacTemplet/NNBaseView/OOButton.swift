//
//  OOButton.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/3/21.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import Cocoa

/// [需求定制]绘制圆形图像,用于列表圆形头像显示
@objcMembers
class OOButton: NSButton {

    var titleColor: NSColor?
    var backgroundColor: NSColor?
    var backgroundImage: NSImage?

    var strokeColor: NSColor?
    var fillColor: NSColor?
    var lineWidth: CGFloat = 0
    var lineColor: NSColor?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let stroke = strokeColor ?? .red
        let fill = fillColor ?? .orange
        lineWidth = 4

        stroke.setStroke()
        fill.setFill()

        let rect = CGRect(x: lineWidth,
                          y: lineWidth,
                          width: dirtyRect.width - lineWidth * 2,
                          height: dirtyRect.height - lineWidth * 2)
        let path = NSBezierPath(ovalIn: rect)
        path.lineWidth = lineWidth
        path.stroke()
        path.fill()

        let drawImage = self.image ?? Self.image(with: fill)
        NSGraphicsContext.saveGraphicsState()
        path.addClip()
        drawImage.draw(in: rect,
                       from: .zero,
                       operation: .sourceOver,
                       fraction: 1.0,
                       respectFlipped: true,
                       hints: nil)
        NSGraphicsContext.restoreGraphicsState()

        if !title.isEmpty {
            let paraStyle = (NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle)
            paraStyle.alignment = alignment

            let attrDic: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paraStyle,
                .foregroundColor: titleColor ?? .labelColor,
                .font: font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize),
            ]
            let attString = NSAttributedString(string: title, attributes: attrDic)
            let fontHeight = ceil((font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)).boundingRectForFont.height)
            let gapY = bounds.midY - fontHeight / 2
            attString.draw(in: NSRect(x: 0, y: gapY, width: frame.size.width, height: fontHeight))
        }
    }

    private static func image(with color: NSColor) -> NSImage {
        let image = NSImage(size: NSSize(width: 1, height: 1))
        image.lockFocus()
        color.drawSwatch(in: NSRect(x: 0, y: 0, width: 1, height: 1))
        image.unlockFocus()
        return image
    }
}
