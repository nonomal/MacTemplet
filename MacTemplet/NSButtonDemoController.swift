//
//  NSButtonDemoController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2026/8/4.
//  Copyright © 2026 Bin Shang. All rights reserved.
//

import Cocoa
import SwiftExpand

/// 系统 NSButton 样式一览：BezelStyle、ButtonType、边框/图像变体，末尾含 NNButtonCell 示例。
@objcMembers class NSButtonDemoController: NSViewController {

    private lazy var scrollView: NSScrollView = {
        let view = NSScrollView()
        view.hasVerticalScroller = true
        view.hasHorizontalScroller = true
        view.autohidesScrollers = true
        view.borderType = .bezelBorder
        view.drawsBackground = false
        view.documentView = wrapView
        return view
    }()

    private lazy var wrapView: NNWrapView = {
        let view = NNWrapView(frame: .zero)
        view.direction = .horizontal
        view.alignment = .start
        view.runAlignment = .start
        view.crossAxisAlignment = .center
        view.spacing = 10
        view.runSpacing = 10
        view.textDirection = .ltr
        view.verticalDirection = .down
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        view.layer?.cornerRadius = 6
        return view
    }()

    private var demoViews: [NSView] = []
    private var isUpdatingWrapFrame = false

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NSButton Demo"
        view.wantsLayer = true

        demoViews = buildDemoViews()
        wrapView.replaceArrangedSubviews(demoViews)

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
        ])
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        updateWrapDocumentFrameIfNeeded()
    }

    private func updateWrapDocumentFrameIfNeeded() {
        guard !isUpdatingWrapFrame else { return }
        isUpdatingWrapFrame = true
        defer { isUpdatingWrapFrame = false }

        let width = max(scrollView.contentSize.width, scrollView.bounds.width - 2, 1)
        let probe = NSRect(x: 0, y: 0, width: width, height: max(wrapView.bounds.height, 1))
        if abs(wrapView.frame.width - probe.width) > 0.5 {
            wrapView.frame = probe
        }
        wrapView.needsLayout = true
        wrapView.layoutSubtreeIfNeeded()

        let fitted = wrapView.fittedContentSize
        let newFrame = NSRect(x: 0, y: 0,
                              width: max(width, fitted.width),
                              height: max(fitted.height, 1))
        if abs(wrapView.frame.width - newFrame.width) > 0.5
            || abs(wrapView.frame.height - newFrame.height) > 0.5 {
            wrapView.frame = newFrame
        }
    }

    // MARK: - demo builders

    private func buildDemoViews() -> [NSView] {
        var views: [NSView] = []

        views.append(sectionHeader("BezelStyle（系统边框样式）"))
        views.append(contentsOf: bezelStyleButtons())

        views.append(sectionHeader("ButtonType（按钮行为）"))
        views.append(contentsOf: buttonTypeButtons())

        views.append(sectionHeader("变体：边框 / 图像"))
        views.append(contentsOf: variantButtons())

        views.append(sectionHeader("NNButtonCell（contentInsets / cornerRadius）"))
        views.append(contentsOf: nnButtonCellButtons())

        return views
    }

    private func sectionHeader(_ text: String) -> NSView {
        let label = NSTextField(labelWithString: text)
        label.font = NSFont.boldSystemFont(ofSize: 13)
        if #available(macOS 10.14, *) {
            label.textColor = NSColor.secondaryLabelColor
        } else {
            label.textColor = NSColor.gray
        }
        label.sizeToFit()
        return label
    }

    private func bezelStyleButtons() -> [NSButton] {
        var specs: [(NSButton.BezelStyle, String)] = [
            (.rounded, "rounded"),
            (.regularSquare, "regularSquare"),
            (.disclosure, "disclosure"),
            (.shadowlessSquare, "shadowlessSquare"),
            (.circular, "circular"),
            (.texturedSquare, "texturedSquare"),
            (.helpButton, "helpButton"),
            (.smallSquare, "smallSquare"),
            (.texturedRounded, "texturedRounded"),
            (.roundRect, "roundRect"),
            (.recessed, "recessed"),
            (.roundedDisclosure, "roundedDisclosure"),
        ]

        if #available(macOS 10.14, *) {
            specs.append((.inline, "inline"))
        }
        if #available(macOS 11.0, *) {
            specs.append((.accessoryBarAction, "accessoryBarAction"))
            specs.append((.toolbar, "toolbar"))
            specs.append((.badge, "badge"))
        }
        if #available(macOS 12.0, *) {
            specs.append((.push, "push"))
            specs.append((.flexiblePush, "flexiblePush"))
        }

        return specs.map { style, name in
            makeBezelButton(style: style, title: name)
        }
    }

    private func makeBezelButton(style: NSButton.BezelStyle, title: String) -> NSButton {
        let hidesTitle: Bool = [
            .disclosure, .circular, .helpButton, .roundedDisclosure,
        ].contains(style)

        let displayTitle = hidesTitle ? "" : title
        let button = NSButton(title: displayTitle, target: self, action: #selector(onDemoButton(_:)))
        button.bezelStyle = style
        button.setButtonType(.momentaryPushIn)
        button.toolTip = "NSButton.BezelStyle.\(title)"

        if style == .inline {
            if #available(macOS 10.14, *) {
                button.isBordered = false
            }
        }

        if #available(macOS 10.12.2, *) {
            if style == .recessed || style == .rounded {
                if #available(macOS 10.14, *) {
                    button.bezelColor = NSColor.controlAccentColor
                } else {
                    button.bezelColor = NSColor.blue
                }
            }
        }

        button.sizeToFit()
        return button
    }

    private func buttonTypeButtons() -> [NSButton] {
        let specs: [(NSButton.ButtonType, String, NSButton.BezelStyle)] = [
            (.momentaryPushIn, "momentaryPushIn", .rounded),
            (.momentaryLight, "momentaryLight", .rounded),
            (.momentaryChange, "momentaryChange", .rounded),
            (.pushOnPushOff, "pushOnPushOff", .rounded),
            (.toggle, "toggle", .rounded),
            (.onOff, "onOff", .rounded),
            (.switch, "switch (checkbox)", .regularSquare),
            (.accelerator, "accelerator", .smallSquare),
            (.multiLevelAccelerator, "multiLevelAccelerator", .smallSquare),
        ]

        var buttons = specs.map { type, name, bezel in
            let button = NSButton(title: name, target: self, action: #selector(onDemoButton(_:)))
            button.setButtonType(type)
            button.bezelStyle = bezel
            button.toolTip = "NSButton.ButtonType.\(name.components(separatedBy: " ").first ?? name)"
            button.sizeToFit()
            return button
        }

        let radioA = NSButton(radioButtonWithTitle: "radio A", target: self, action: #selector(onRadio(_:)))
        radioA.tag = 100
        radioA.state = .on
        radioA.toolTip = "NSButton.ButtonType.radio"
        radioA.sizeToFit()

        let radioB = NSButton(radioButtonWithTitle: "radio B", target: self, action: #selector(onRadio(_:)))
        radioB.tag = 100
        radioB.toolTip = "NSButton.ButtonType.radio"
        radioB.sizeToFit()

        buttons.append(contentsOf: [radioA, radioB])
        return buttons
    }

    private func variantButtons() -> [NSButton] {
        var buttons: [NSButton] = []

        let bordered = NSButton(title: "bordered", target: self, action: #selector(onDemoButton(_:)))
        bordered.bezelStyle = .rounded
        bordered.isBordered = true
        bordered.toolTip = "isBordered = true"
        bordered.sizeToFit()
        buttons.append(bordered)

        let borderless = NSButton(title: "borderless", target: self, action: #selector(onDemoButton(_:)))
        borderless.bezelStyle = .shadowlessSquare
        borderless.isBordered = false
        borderless.toolTip = "isBordered = false, shadowlessSquare"
        borderless.sizeToFit()
        buttons.append(borderless)

        let withImage = NSButton(title: "title + image", target: self, action: #selector(onDemoButton(_:)))
        withImage.bezelStyle = .rounded
        withImage.image = demoImage()
        withImage.imagePosition = .imageLeading
        withImage.sizeToFit()
        buttons.append(withImage)

        let imageOnly = NSButton(image: demoImage(), target: self, action: #selector(onDemoButton(_:)))
        imageOnly.bezelStyle = .regularSquare
        imageOnly.imagePosition = .imageOnly
        imageOnly.toolTip = "imageOnly"
        imageOnly.sizeToFit()
        buttons.append(imageOnly)

        if #available(macOS 11.0, *) {
            if let symbol = NSImage(systemSymbolName: "star.fill", accessibilityDescription: "star") {
                let sfButton = NSButton(title: "SF Symbol", target: self, action: #selector(onDemoButton(_:)))
                sfButton.bezelStyle = .rounded
                sfButton.image = symbol
                sfButton.imagePosition = .imageLeading
                sfButton.sizeToFit()
                buttons.append(sfButton)
            }
        }

        return buttons
    }

    private func nnButtonCellButtons() -> [NSButton] {
        let specs: [(String, NSEdgeInsets, CGFloat)] = [
            ("NNCell default", NSEdgeInsets(top: 4, left: 8, bottom: 4, right: 8), 0),
            ("NNCell insets 12", NSEdgeInsets(top: 12, left: 16, bottom: 12, right: 16), 0),
            ("NNCell radius 8", NSEdgeInsets(top: 4, left: 8, bottom: 4, right: 8), 8),
            ("NNCell insets+radius", NSEdgeInsets(top: 8, left: 12, bottom: 8, right: 12), 12),
        ]

        return specs.map { title, insets, radius in
            let cell = NNButtonCell(textCell: title)
            cell.contentInsets = insets
            cell.cornerRadius = radius

            let button = NSButton(title: title, target: self, action: #selector(onDemoButton(_:)))
            button.cell = cell
            button.bezelStyle = .smallSquare
            button.toolTip = "NNButtonCell contentInsets / cornerRadius"
            button.sizeToFit()
            return button
        }
    }

    private func demoImage() -> NSImage {
        if let image = NSImage(named: "AppIcon") {
            return image
        }
        return NSImage(size: NSSize(width: 16, height: 16), flipped: false) { rect in
            NSColor.blue.setFill()
            rect.fill()
            return true
        }
    }

    // MARK: - actions

    @objc private func onDemoButton(_ sender: NSButton) {
        DDLog("NSButtonDemo tap: \(sender.toolTip ?? sender.title)")
    }

    @objc private func onRadio(_ sender: NSButton) {
        for button in demoViews.compactMap({ $0 as? NSButton }) where button.tag == sender.tag {
            button.state = (button === sender) ? .on : .off
        }
        DDLog("NSButtonDemo radio: \(sender.title)")
    }
}
