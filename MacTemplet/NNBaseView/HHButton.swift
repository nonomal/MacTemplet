//
//  HHButton.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/27.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objc
enum NNButtonState: UInt {
    @objc(NNButtonNormalState) case normal = 0
    @objc(NNButtonHoverState) case hover = 1
    @objc(NNButtonHighlightState) case highlight = 2
    @objc(NNButtonSelectedState) case selected = 3
}

/// Local AppKit button with hover/highlight/selected appearance.
/// Coexists with `NNButton` as a parallel widget — not a deprecated alias; do not force-migrate call sites to `NNButton`.
@objcMembers
class HHButton: NSButton {

    var backgroundColor: NSColor? {
        didSet { needsDisplay = true }
    }
    var titleColor: NSColor?

    var canSelected = true {
        didSet { updateButtonApperace(with: buttonState) }
    }
    var hasBorder = false {
        didSet { updateButtonApperace(with: buttonState) }
    }

    var cornerNormalRadius: CGFloat = 0
    var cornerHoverRadius: CGFloat = 0
    var cornerHighlightRadius: CGFloat = 0
    var cornerSelectedRadius: CGFloat = 0

    var borderNormalWidth: CGFloat = 0
    var borderHoverWidth: CGFloat = 0
    var borderHighlightWidth: CGFloat = 0
    var borderSelectedWidth: CGFloat = 0

    var borderNormalColor: NSColor?
    var borderHoverColor: NSColor?
    var borderHighlightColor: NSColor?
    var borderSelectedColor: NSColor?

    var normalColor: NSColor?
    var hoverColor: NSColor?
    var highlightColor: NSColor?
    var selectedColor: NSColor?

    var normalImage: NSImage?
    var hoverImage: NSImage?
    var highlightImage: NSImage?
    var selectedImage: NSImage?

    var backgroundNormalColor: NSColor?
    var backgroundHoverColor: NSColor?
    var backgroundHighlightColor: NSColor?
    var backgroundSelectedColor: NSColor?

    var buttonState: NNButtonState = .normal {
        didSet {
            guard oldValue != buttonState else { return }
            isButtonSelected = (buttonState == .selected)
            updateButtonApperace(with: buttonState)
        }
    }

    private var isButtonSelected = false
    private var hover = false
    private var trackingArea: NSTrackingArea?
    private var defaultImage: NSImage?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let bgColor = backgroundColor ?? .white
        bgColor.set()
        bounds.fill()

        if let image = image {
            image.draw(in: bounds)
        }

        if !title.isEmpty {
            let paraStyle = (NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle)
            paraStyle.alignment = alignment

            let currentFont = font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
            let attrDic: [NSAttributedString.Key: Any] = [
                .font: currentFont,
                .foregroundColor: titleColor ?? .black,
                .paragraphStyle: paraStyle,
            ]
            let attString = NSAttributedString(string: title, attributes: attrDic)
            let fontHeight = ceil(currentFont.boundingRectForFont.height)
            let gapY = bounds.midY - fontHeight / 2
            attString.draw(in: NSRect(x: 0, y: gapY, width: frame.size.width, height: fontHeight))
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInitialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitialize()
    }

    override func viewWillMove(toSuperview newSuperview: NSView?) {
        super.viewWillMove(toSuperview: newSuperview)
        updateButtonApperace(with: buttonState)
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if let trackingArea = trackingArea {
            removeTrackingArea(trackingArea)
            self.trackingArea = nil
        }
        let options: NSTrackingArea.Options = [.inVisibleRect, .mouseEnteredAndExited, .activeAlways]
        trackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        if let trackingArea = trackingArea {
            addTrackingArea(trackingArea)
        }
    }

    override func mouseEntered(with event: NSEvent) {
        hover = true
        buttonState = .hover
    }

    override func mouseExited(with event: NSEvent) {
        hover = false
        if !isButtonSelected {
            buttonState = .normal
        }
    }

    override func mouseDown(with event: NSEvent) {
        if isEnabled && !isButtonSelected {
            buttonState = .highlight
        }
    }

    override func mouseUp(with event: NSEvent) {
        guard isEnabled else { return }

        if canSelected && hover {
            isButtonSelected.toggle()
            buttonState = isButtonSelected ? .selected : .normal
        } else if !isButtonSelected {
            buttonState = .normal
        }

        if hover, let action = action {
            NSApp.sendAction(action, to: target, from: self)
        }
    }

    private func commonInitialize() {
        canSelected = true
        initializeUI()
    }

    private func initializeUI() {
        wantsLayer = true
        setButtonType(.momentaryPushIn)
        bezelStyle = .texturedSquare
        isBordered = false
        setFontColor(normalColor)
    }

    private func setFontColor(_ color: NSColor?) {
        titleColor = color
        needsDisplay = true
    }

    private func updateButtonApperace(with state: NNButtonState) {
        var cornerRadius: CGFloat = 0
        var borderWidth: CGFloat = 0
        var borderColor: NSColor?
        var themeColor: NSColor?
        var bgColor: NSColor?

        switch state {
        case .normal:
            cornerRadius = cornerNormalRadius > 0 ? cornerNormalRadius : (layer?.cornerRadius ?? 0)
            borderWidth = borderNormalWidth > 0 ? borderNormalWidth : (layer?.borderWidth ?? 0)
            borderColor = borderNormalColor ?? layer?.borderColor.map { NSColor(cgColor: $0) ?? .clear }
            themeColor = normalColor
            bgColor = backgroundNormalColor ?? backgroundColor
            if let normalImage = normalImage {
                defaultImage = normalImage
            }
        case .hover:
            cornerRadius = cornerHoverRadius > 0 ? cornerHoverRadius : (layer?.cornerRadius ?? 0)
            borderWidth = borderHoverWidth > 0 ? borderHoverWidth : (layer?.borderWidth ?? 0)
            borderColor = borderHoverColor ?? layer?.borderColor.map { NSColor(cgColor: $0) ?? .clear }
            themeColor = hoverColor
            bgColor = backgroundHoverColor ?? backgroundColor
            if let hoverImage = hoverImage {
                defaultImage = hoverImage
            }
        case .highlight:
            cornerRadius = cornerHighlightRadius > 0 ? cornerHighlightRadius : (layer?.cornerRadius ?? 0)
            borderWidth = borderHighlightWidth > 0 ? borderHighlightWidth : (layer?.borderWidth ?? 0)
            borderColor = borderHighlightColor ?? layer?.borderColor.map { NSColor(cgColor: $0) ?? .clear }
            themeColor = highlightColor
            bgColor = backgroundHighlightColor ?? backgroundColor
            if let highlightImage = highlightImage {
                defaultImage = highlightImage
            }
        case .selected:
            cornerRadius = cornerSelectedRadius > 0 ? cornerSelectedRadius : (layer?.cornerRadius ?? 0)
            borderWidth = borderSelectedWidth > 0 ? borderSelectedWidth : (layer?.borderWidth ?? 0)
            borderColor = borderSelectedColor ?? layer?.borderColor.map { NSColor(cgColor: $0) ?? .clear }
            themeColor = selectedColor
            bgColor = backgroundSelectedColor ?? backgroundColor
            if let selectedImage = selectedImage {
                defaultImage = selectedImage
            }
        @unknown default:
            break
        }

        if let defaultImage = defaultImage {
            image = defaultImage
        }
        setFontColor(themeColor)
        backgroundColor = bgColor

        if hasBorder {
            layer?.cornerRadius = cornerRadius
            layer?.borderWidth = borderWidth
            layer?.borderColor = borderColor?.cgColor
        } else {
            layer?.cornerRadius = 0
            layer?.borderWidth = 0
            layer?.borderColor = NSColor.clear.cgColor
        }
    }

    override var title: String {
        get { super.title }
        set {
            super.title = newValue
            setFontColor(normalColor)
        }
    }
}
