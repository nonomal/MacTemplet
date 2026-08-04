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

    /// top / left / bottom / right，默认 {6, 8, 6, 8}
    var contentInsets = NSEdgeInsets(top: 6, left: 8, bottom: 6, right: 8) {
        didSet { invalidateControlSize() }
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

    /// 系统测量的内容尺寸 + contentInsets，不受当前 control 小 frame 影响。
    /// 必须用 `super.cellSize(forBounds:)`：访问 `super.cellSize` 会回调本类 `cellSize(forBounds:)` 导致栈溢出。
    /// 勿用 `greatestFiniteMagnitude` 作测量 bounds：AppKit 会返回 width 0，按钮只剩 padding 宽。
    private func paddedFittingSize() -> NSSize {
        let unbounded = NSRect(x: 0, y: 0, width: 10_000, height: 10_000)
        var size = super.cellSize(forBounds: unbounded)
        let measured = measuredContentSize()
        size.width = max(size.width, measured.width)
        size.height = max(size.height, measured.height)
        size.width += contentInsets.left + contentInsets.right
        size.height += contentInsets.top + contentInsets.bottom
        return NSSize(width: ceil(size.width), height: ceil(size.height))
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
