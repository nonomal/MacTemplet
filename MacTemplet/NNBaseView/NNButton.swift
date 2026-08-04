//
//  NNButton.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/3/20.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import Cocoa

@objc enum NNControlState: Int {
    case normal = 1
    case highlighted = 2
    case disabled = 4
    case selected = 8
    case hover = 16
}

@objc enum NNButtonType: Int {
    @objc(NNButtonTypeText) case typeText = 0
    @objc(NNButtonType1) case type1 = 1
    @objc(NNButtonType2) case type2 = 2
}

private let kTitle = "title"
private let kTitleColor = "titleColor"
private let kBackgroundImage = "backgroundImage"
private let kAttributedTitle = "AttributedTitle"
private let kBorderColor = "BorderColor"
private let kBorderWidth = "BorderWidth"
private let kCornerRadius = "CornerRadius"

@objcMembers
class NNButton: NSButton {

    @objc(nnButtonType)
    var buttonType: NNButtonType = .typeText
    var block: ((NNButton, NNControlState) -> Void)?
    var selected: Bool = false {
        didSet {
            if !isEnabled { return }
            setButtonState(selected ? .selected : .normal)
        }
    }
    var showHighlighted: Bool = false
    var isAttributedTitle: Bool = false
    var titleColor: NSColor?
    var backgroundColor: NSColor?
    var backgroundImage: NSImage?
    /// Rounded-rect radii for background drawing (from former RRButton).
    var xRadius: CGFloat = 0 {
        didSet { needsDisplay = true }
    }
    var YRadius: CGFloat = 0 {
        didSet { needsDisplay = true }
    }

    private var hover: Bool = false
    private var mouseUp: Bool = false
    private var trackingArea: NSTrackingArea?
    private var mdic: NSMutableDictionary?
    private var mdicState: NSMutableDictionary?
    private var mdicNormal: NSMutableDictionary?
    private var mdicHighlighted: NSMutableDictionary?
    private var mdicDisabled: NSMutableDictionary?
    private var mdicSelected: NSMutableDictionary?
    private var mdicHover: NSMutableDictionary?
    private var buttonState: NNControlState = .normal

    deinit {
        removeObserver(self, forKeyPath: "enabled")
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addObserver(self, forKeyPath: "enabled", options: .new, context: nil)
        wantsLayer = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addObserver(self, forKeyPath: "enabled", options: .new, context: nil)
        wantsLayer = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let image = backgroundImage ?? NSImage.imageWithColor(backgroundColor ?? .white)
        if xRadius > 0 || YRadius > 0 {
            let path = NSBezierPath(roundedRect: bounds, xRadius: xRadius, yRadius: YRadius)
            NSGraphicsContext.saveGraphicsState()
            path.addClip()
            image.draw(in: bounds)
            if let backgroundColor = backgroundColor {
                backgroundColor.setFill()
                path.fill()
            }
            NSGraphicsContext.restoreGraphicsState()
            layer?.masksToBounds = true
            layer?.cornerRadius = max(xRadius, YRadius)
        } else {
            image.draw(in: bounds)
        }

        let padding: CGFloat = 8.0
        if isAttributedTitle {
            drawAttributedString(attributedTitle, padding: padding)
        } else {
            let paraStyle = (NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle)
            paraStyle.alignment = alignment.rawValue == 0 ? .center : alignment
            paraStyle.lineBreakMode = lineBreakMode.rawValue == 0 ? .byWordWrapping : lineBreakMode

            let attrDic: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paraStyle,
                .foregroundColor: titleColor ?? NSColor.labelColor,
                .font: font as Any
            ]

            let attString = NSAttributedString(string: title, attributes: attrDic)
            drawAttributedString(attString, padding: padding)
        }
    }

    override func viewWillMove(toSuperview newSuperview: NSView?) {
        super.viewWillMove(toSuperview: newSuperview)
        updateUIWithState(buttonState)
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if let trackingArea = trackingArea {
            removeTrackingArea(trackingArea)
            self.trackingArea = nil
        }
        let options: NSTrackingArea.Options = [.inVisibleRect, .mouseEnteredAndExited, .activeAlways]
        trackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        addTrackingArea(trackingArea!)
    }

    override func mouseEntered(with event: NSEvent) {
        setHover(true)
    }

    override func mouseExited(with event: NSEvent) {
        setHover(false)
    }

    override func mouseDown(with event: NSEvent) {
        setMouseUpValue(false)
    }

    override func mouseUp(with event: NSEvent) {
        setMouseUpValue(true)
    }

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == "enabled" {
            let valueNew = change?[.newKey] as? NSNumber
            setButtonState(valueNew?.boolValue == false ? .disabled : .normal)
        }
    }

    private func drawAttributedString(_ attributedString: NSAttributedString, padding: CGFloat) {
        let maxSize = CGSize(width: bounds.size.width - padding * 2, height: CGFloat.greatestFiniteMagnitude)
        let size = attributedString.boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).size

        let gapX = padding + (maxSize.width - size.width) / 2
        let gapY = (bounds.height - size.height) / 2
        let contentRect = NSRect(x: floor(gapX), y: floor(gapY), width: size.width, height: size.height)
        attributedString.draw(in: contentRect)
    }

    convenience init(type buttonType: NNButtonType) {
        self.init(frame: .zero)
        self.buttonType = buttonType
        setTitle("NNButton", for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        switch buttonType {
        case .type1:
            setTitleColor(.labelColor, for: .normal)
        case .type2:
            setTitleColor(.white, for: .normal)
            let image = NSImage.imageWithColor(NSColor.hexValue(0x29B5FE, alpha: 1))
            setBackgroundImage(image, for: .normal)
        default:
            break
        }
    }

    @objc(buttonWithType:)
    class func button(withType buttonType: NNButtonType) -> NNButton {
        return NNButton(type: buttonType)
    }

    func setTitle(_ title: String?, for state: NNControlState) {
        guard let title = title else { return }
        if state == .normal {
            self.title = title
            stateDictionary(for: .hover)[kTitle] = title
            stateDictionary(for: .selected)[kTitle] = title
            stateDictionary(for: .highlighted)[kTitle] = title
            stateDictionary(for: .disabled)[kTitle] = title
        }
        stateDictionary(for: state)[kTitle] = title
    }

    func setTitleColor(_ color: NSColor?, for state: NNControlState) {
        guard let color = color else { return }
        if state == .normal {
            titleColor = color
            stateDictionary(for: .hover)[kTitleColor] = color
            stateDictionary(for: .hover)[kBorderColor] = color
        }
        stateDictionary(for: state)[kTitleColor] = color
        stateDictionary(for: state)[kBorderColor] = color
    }

    func setAttributedTitle(_ title: NSAttributedString?, for state: NNControlState) {
        guard let title = title else { return }
        if state == .normal {
            self.title = title.string
            stateDictionary(for: .hover)[kAttributedTitle] = title
            stateDictionary(for: .selected)[kAttributedTitle] = title
            stateDictionary(for: .highlighted)[kAttributedTitle] = title
            stateDictionary(for: .disabled)[kAttributedTitle] = title
        }
        stateDictionary(for: state)[kAttributedTitle] = title
    }

    func setBackgroundImage(_ image: NSImage?, for state: NNControlState) {
        guard let image = image else { return }
        if state == .normal {
            stateDictionary(for: .hover)[kBackgroundImage] = image
            stateDictionary(for: .selected)[kBackgroundImage] = image
            stateDictionary(for: .highlighted)[kBackgroundImage] = image
            stateDictionary(for: .disabled)[kBackgroundImage] = image
        }
        stateDictionary(for: state)[kBackgroundImage] = image
    }

    func setBorderColor(_ color: NSColor?, for state: NNControlState) {
        guard let color = color else { return }
        if state == .normal {
            stateDictionary(for: .hover)[kBorderColor] = color
            stateDictionary(for: .selected)[kBorderColor] = color
            stateDictionary(for: .highlighted)[kBorderColor] = color
            stateDictionary(for: .disabled)[kBorderColor] = color
        }
        stateDictionary(for: state)[kBorderColor] = color
    }

    func setBorderWidth(_ number: NSNumber?, for state: NNControlState) {
        guard let number = number else { return }
        if state == .normal {
            stateDictionary(for: .hover)[kBorderWidth] = number
            stateDictionary(for: .selected)[kBorderWidth] = number
            stateDictionary(for: .highlighted)[kBorderWidth] = number
            stateDictionary(for: .disabled)[kBorderWidth] = number
        }
        stateDictionary(for: state)[kBorderWidth] = number
    }

    func setCornerRadius(_ number: NSNumber?, for state: NNControlState) {
        guard let number = number else { return }
        if state == .normal {
            stateDictionary(for: .hover)[kCornerRadius] = number
            stateDictionary(for: .selected)[kCornerRadius] = number
            stateDictionary(for: .highlighted)[kCornerRadius] = number
            stateDictionary(for: .disabled)[kCornerRadius] = number
        }
        stateDictionary(for: state)[kCornerRadius] = number
    }

    func title(for state: NNControlState) -> String? {
        return stateDictionary(for: state)[kTitle] as? String
            ?? stateDictionary(for: .normal)[kTitle] as? String
    }

    func titleColor(for state: NNControlState) -> NSColor? {
        return stateDictionary(for: state)[kTitleColor] as? NSColor
            ?? stateDictionary(for: .normal)[kTitleColor] as? NSColor
    }

    func attributedString(for state: NNControlState) -> NSAttributedString? {
        return stateDictionary(for: state)[kAttributedTitle] as? NSAttributedString
            ?? stateDictionary(for: .normal)[kAttributedTitle] as? NSAttributedString
    }

    func backgroundImage(for state: NNControlState) -> NSImage? {
        return stateDictionary(for: state)[kBackgroundImage] as? NSImage
            ?? stateDictionary(for: .normal)[kBackgroundImage] as? NSImage
    }

    func borderColor(for state: NNControlState) -> NSColor? {
        return stateDictionary(for: state)[kBorderColor] as? NSColor
            ?? stateDictionary(for: .normal)[kBorderColor] as? NSColor
    }

    func borderWidth(for state: NNControlState) -> NSNumber? {
        return stateDictionary(for: state)[kBorderWidth] as? NSNumber
            ?? stateDictionary(for: .normal)[kBorderWidth] as? NSNumber
    }

    func cornerRadius(for state: NNControlState) -> NSNumber? {
        return stateDictionary(for: state)[kCornerRadius] as? NSNumber
            ?? stateDictionary(for: .normal)[kCornerRadius] as? NSNumber
    }

    private func updateUIWithState(_ state: NNControlState) {
        block?(self, state)
        if state == .highlighted && showHighlighted == false {
            return
        }

        if let stateDic = ensureMdic()[stateKey(state)] as? NSMutableDictionary {
            mdicState = stateDic
        } else {
            mdicState = stateDictionary(for: .normal)
        }

        title = (mdicState?[kTitle] as? String) ?? title
        titleColor = mdicState?[kTitleColor] as? NSColor
        backgroundImage = mdicState?[kBackgroundImage] as? NSImage

        switch buttonType {
        case .type1:
            if state == .disabled {
                layer?.borderColor = NSColor.lightGray.cgColor
            } else if let borderColor = mdicState?[kBorderColor] as? NSColor {
                if borderColor.cgColor != NSColor.clear.cgColor {
                    layer?.borderColor = borderColor.cgColor
                }
            }
            if let borderWidth = mdicState?[kBorderWidth] as? NSNumber, borderWidth.floatValue > 0 {
                layer?.borderWidth = CGFloat(borderWidth.floatValue)
            }
            if let cornerRadius = mdicState?[kCornerRadius] as? NSNumber, cornerRadius.floatValue > 0 {
                layer?.cornerRadius = CGFloat(cornerRadius.floatValue)
            }
        case .type2:
            if state == .disabled {
                titleColor = .white
                backgroundImage = NSImage.imageWithColor(.lightGray)
            }
        default:
            layer?.borderColor = NSColor.clear.cgColor
            layer?.borderWidth = 0
            layer?.cornerRadius = 0
        }
        setNeedsDisplay(bounds)
    }

    func stateBlock(_ block: @escaping (NNButton, NNControlState) -> Void) {
        self.block = block
    }

    private func stateKey(_ state: NNControlState) -> NSNumber {
        return NSNumber(value: state.rawValue)
    }

    private func stateDictionary(for state: NNControlState) -> NSMutableDictionary {
        return ensureMdic()[stateKey(state)] as! NSMutableDictionary
    }

    private func ensureMdic() -> NSMutableDictionary {
        if mdic == nil {
            mdic = [
                stateKey(.normal): ensureMdicNormal(),
                stateKey(.highlighted): ensureMdicHighlighted(),
                stateKey(.disabled): ensureMdicDisabled(),
                stateKey(.selected): ensureMdicSelected(),
                stateKey(.hover): ensureMdicHover()
            ]
        }
        return mdic!
    }

    private func ensureMdicNormal() -> NSMutableDictionary {
        if mdicNormal == nil {
            mdicNormal = [
                kTitle: title as Any,
                kTitleColor: NSColor.labelColor,
                kBackgroundImage: NSImage.imageWithColor(.white),
                kCornerRadius: NSNumber(value: 0.0),
                kBorderWidth: NSNumber(value: 1.0),
                kBorderColor: NSColor.clear
            ]
        }
        return mdicNormal!
    }

    private func ensureMdicHighlighted() -> NSMutableDictionary {
        if mdicHighlighted == nil {
            mdicHighlighted = [
                kTitle: title as Any,
                kTitleColor: NSColor.labelColor,
                kBackgroundImage: NSImage.imageWithColor(.systemBlue),
                kCornerRadius: NSNumber(value: 0.0),
                kBorderWidth: NSNumber(value: 1.0),
                kBorderColor: NSColor.clear
            ]
        }
        return mdicHighlighted!
    }

    private func ensureMdicDisabled() -> NSMutableDictionary {
        if mdicDisabled == nil {
            mdicDisabled = [
                kTitle: title as Any,
                kTitleColor: NSColor.lightGray,
                kBackgroundImage: NSImage.imageWithColor(.white),
                kCornerRadius: NSNumber(value: 0.0),
                kBorderWidth: NSNumber(value: 1.0),
                kBorderColor: NSColor.clear
            ]
        }
        return mdicDisabled!
    }

    private func ensureMdicSelected() -> NSMutableDictionary {
        if mdicSelected == nil {
            mdicSelected = [
                kTitle: title as Any,
                kTitleColor: NSColor.labelColor,
                kBackgroundImage: NSImage.imageWithColor(.white),
                kCornerRadius: NSNumber(value: 0.0),
                kBorderWidth: NSNumber(value: 1.0),
                kBorderColor: NSColor.clear
            ]
        }
        return mdicSelected!
    }

    private func ensureMdicHover() -> NSMutableDictionary {
        if mdicHover == nil {
            mdicHover = [
                kTitle: title as Any,
                kTitleColor: NSColor.labelColor,
                kBackgroundImage: NSImage.imageWithColor(.white),
                kCornerRadius: NSNumber(value: 0.0),
                kBorderWidth: NSNumber(value: 1.0),
                kBorderColor: NSColor.clear
            ]
        }
        return mdicHover!
    }

    private func setButtonState(_ state: NNControlState) {
        buttonState = state
        updateUIWithState(state)
    }

    private func setHover(_ value: Bool) {
        hover = value
        if !isEnabled { return }

        if value {
            setButtonState(.hover)
        } else {
            setButtonState(selected ? .selected : .normal)
        }
    }

    private func setMouseUpValue(_ value: Bool) {
        mouseUp = value
        if !isEnabled { return }

        if value {
            setButtonState(selected ? .selected : .normal)
        } else {
            setButtonState(.highlighted)
        }

        if hover && isEnabled && value, let action = action {
            let selString = NSStringFromSelector(action)
            if selString.hasSuffix(":") {
                _ = target?.perform(action, with: self, afterDelay: 0)
            } else {
                _ = target?.perform(action, with: nil, afterDelay: 0)
            }
        }
    }
}
