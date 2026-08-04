//
//  NNButtonCell.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/3/21.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import Cocoa

/// 带内容内边距的按钮 Cell：在 `drawInterior` 中内缩绘制区域，并在 `cellSize` 中把内边距算进按钮固有尺寸。
@objcMembers
class NNButtonCell: NSButtonCell {

    /// top / left / bottom / right，默认 {4, 8, 4, 8},仅 bezelStyle = .smallSquare 生效
    var contentInsets = NSEdgeInsets(top: 4, left: 8, bottom: 4, right: 8) {
        didSet { invalidateControlSize() }
    }

    /// 圆角半径，默认 0（不圆角）。> 0 时在 cell 层绘制圆角 bezel 并裁剪内容。
    var cornerRadius: CGFloat = 0 {
        didSet {
            guard cornerRadius != oldValue else { return }
            controlView?.needsDisplay = true
        }
    }

    override init(textCell string: String) {
        super.init(textCell: string)
    }

    override init(imageCell image: NSImage?) {
        super.init(imageCell: image)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func copy(with zone: NSZone? = nil) -> Any {
        let copied = super.copy(with: zone) as! NNButtonCell
        copied.contentInsets = contentInsets
        copied.cornerRadius = cornerRadius
        return copied
    }

    private var isInvalidatingSize = false

    private func invalidateControlSize() {
        guard !isInvalidatingSize, let control = controlView as? NSControl else { return }
        isInvalidatingSize = true
        defer { isInvalidatingSize = false }
        control.invalidateIntrinsicContentSize()
        control.needsDisplay = true
        // 非 Auto Layout 场景（如 NNWrapView 手算 frame）依赖 sizeToFit / cellSize
        control.sizeToFit()
    }

    /// Cell 坐标系默认非 flipped：y 从底部起算，故 bottom 对应 y 偏移。
    private func insetBounds(_ rect: NSRect) -> NSRect {
        let insets = contentInsets
        return NSRect(
            x: NSMinX(rect) + insets.left,
            y: NSMinY(rect) + insets.bottom,
            width: max(0, rect.width - insets.left - insets.right),
            height: max(0, rect.height - insets.top - insets.bottom)
        )
    }

    /// 用 attributedTitle / image 测量内容，避免 super.cellSize 在部分 bezel 下过小。
    private func measuredContentSize() -> NSSize {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        ]
        let titleString = attributedTitle.length > 0
            ? attributedTitle
            : NSAttributedString(string: title ?? "", attributes: attrs)
        var size = titleString.size()

        if let image = image {
            switch imagePosition {
            case .imageLeft, .imageRight, .imageLeading, .imageTrailing:
                size.width += image.size.width + (size.width > 0 ? 6 : 0)
                size.height = max(size.height, image.size.height)
            case .imageAbove, .imageBelow:
                size.width = max(size.width, image.size.width)
                size.height += image.size.height + (size.height > 0 ? 4 : 0)
            case .imageOverlaps, .imageOnly:
                size.width = max(size.width, image.size.width)
                size.height = max(size.height, image.size.height)
            default:
                break
            }
        }

        return NSSize(width: ceil(max(size.width, 0)), height: ceil(max(size.height, 0)))
    }

    /// 内容尺寸 + contentInsets，不受当前 control 小 frame 影响。
    /// 不可调用 `super.cellSize` / `super.cellSize(forBounds:)`：现代 AppKit 的 `-[NSCell cellSizeForBounds:]`
    /// 会经 `cellSize` 属性回调本类 override，造成栈溢出（NSButtonDemoController + NNWrapView 必现）。
    private func paddedFittingSize() -> NSSize {
        let measured = measuredContentSize()
        var width = max(measured.width, 1)
        var height = max(measured.height, 22)
        width += contentInsets.left + contentInsets.right
        height += contentInsets.top + contentInsets.bottom
        return NSSize(width: ceil(width), height: ceil(height))
    }

    private func roundedPath(in rect: NSRect) -> NSBezierPath {
        NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
    }

    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        guard cornerRadius > 0 else {
            super.draw(withFrame: cellFrame, in: controlView)
            return
        }

        NSGraphicsContext.saveGraphicsState()
        roundedPath(in: cellFrame).addClip()
        super.draw(withFrame: cellFrame, in: controlView)
        NSGraphicsContext.restoreGraphicsState()
    }

    override func drawBezel(withFrame cellFrame: NSRect, in controlView: NSView) {
        guard cornerRadius > 0 else {
            super.drawBezel(withFrame: cellFrame, in: controlView)
            return
        }

        let path = roundedPath(in: cellFrame)
        if !isEnabled {
            NSColor.controlColor.withAlphaComponent(0.5).setFill()
        } else if isHighlighted {
            NSColor.selectedControlColor.setFill()
        } else {
            NSColor.controlColor.setFill()
        }
        path.fill()

        NSColor.controlShadowColor.setStroke()
        path.lineWidth = 1
        path.stroke()
    }

    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.drawInterior(withFrame: insetBounds(cellFrame), in: controlView)
    }

    override func cellSize(forBounds rect: NSRect) -> NSSize {
        // 始终返回含 padding 的理想尺寸；勿用 min(rect) 钳制，否则 sizeToFit / intrinsic size 会被默认小 frame 压扁。
        paddedFittingSize()
    }

    override var cellSize: NSSize {
        paddedFittingSize()
    }

    override var attributedTitle: NSAttributedString {
        get { super.attributedTitle }
        set {
            super.attributedTitle = newValue
            invalidateControlSize()
        }
    }

    override var title: String? {
        get { super.title }
        set {
            super.title = newValue
            invalidateControlSize()
        }
    }

    override var image: NSImage? {
        get { super.image }
        set {
            super.image = newValue
            invalidateControlSize()
        }
    }
}
