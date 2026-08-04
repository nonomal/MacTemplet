//
//  WrapViewDemoController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2026/8/3.
//  Copyright © 2026 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftExpand

/// NNWrapView（Flutter Wrap）效果调试页：固定 16 个按钮
@objcMembers class WrapViewDemoController: NSViewController {

    private lazy var wrapView: NNWrapView = {
        let view = NNWrapView(frame: .zero)
        view.direction = .horizontal
        view.alignment = .start
        view.runAlignment = .start
        view.crossAxisAlignment = .center
        view.spacing = 8
        view.runSpacing = 8
        view.textDirection = .ltr
        view.verticalDirection = .down
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        view.layer?.cornerRadius = 6
        return view
    }()

    private lazy var scrollView: NSScrollView = {
        let view = NSScrollView()
        view.hasVerticalScroller = true
        view.hasHorizontalScroller = true
        view.autohidesScrollers = true
        view.borderType = .bezelBorder
        view.documentView = wrapView
        return view
    }()

    private lazy var directionPop: NSPopUpButton = makePopup(
        titles: ["horizontal", "vertical"],
        action: #selector(onDirectionChanged(_:))
    )

    private lazy var alignmentPop: NSPopUpButton = makePopup(
        titles: ["start", "end", "center", "spaceBetween", "spaceAround", "spaceEvenly"],
        action: #selector(onAlignmentChanged(_:))
    )

    private lazy var runAlignmentPop: NSPopUpButton = makePopup(
        titles: ["start", "end", "center", "spaceBetween", "spaceAround", "spaceEvenly"],
        action: #selector(onRunAlignmentChanged(_:))
    )

    private lazy var crossAlignmentPop: NSPopUpButton = makePopup(
        titles: ["start", "end", "center", "stretch"],
        action: #selector(onCrossAlignmentChanged(_:))
    )

    private lazy var spacingField: NSTextField = makeNumberField(value: 8, action: #selector(onSpacingChanged(_:)))
    private lazy var runSpacingField: NSTextField = makeNumberField(value: 8, action: #selector(onRunSpacingChanged(_:)))

    private lazy var controlStack: NSStackView = {
        let view = NSStackView()
        view.orientation = .vertical
        view.alignment = .leading
        view.spacing = 8
        view.edgeInsets = NSEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        view.addArrangedSubview(makeLabeledRow("direction", directionPop))
        view.addArrangedSubview(makeLabeledRow("alignment", alignmentPop))
        view.addArrangedSubview(makeLabeledRow("runAlignment", runAlignmentPop))
        view.addArrangedSubview(makeLabeledRow("crossAxisAlignment", crossAlignmentPop))
        view.addArrangedSubview(makeLabeledRow("spacing", spacingField))
        view.addArrangedSubview(makeLabeledRow("runSpacing", runSpacingField))
        return view
    }()

    private var buttons: [NSButton] = []
    private var isUpdatingWrapFrame = false

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WrapViewDemo"
        view.wantsLayer = true

        buttons = (1...16).map { index in
            let title = index % 4 == 0 ? "Btn\(index) 较长标题" : "Btn\(index)"
            let button = NSButton(title: title, target: self, action: #selector(onDemoButton(_:)))
            button.tag = index
            let cell = NNButtonCell(textCell: title)
            cell.contentInsets = NSEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
            button.cell = cell
            button.bezelStyle = .rounded
            button.title = title
            button.target = self
            button.action = #selector(onDemoButton(_:))
            button.sizeToFit()
            return button
        }
        wrapView.replaceArrangedSubviews(buttons)

        view.addSubview(controlStack)
        view.addSubview(scrollView)

        controlStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(controlStack.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }
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

    // MARK: - actions

    @objc private func onDemoButton(_ sender: NSButton) {
        DDLog("WrapViewDemo tap: \(sender.title)")
    }

    @objc private func onDirectionChanged(_ sender: NSPopUpButton) {
        wrapView.direction = sender.indexOfSelectedItem == 0 ? .horizontal : .vertical
        refreshWrapFrame()
    }

    @objc private func onAlignmentChanged(_ sender: NSPopUpButton) {
        wrapView.alignment = NNWrapAlignment(rawValue: sender.indexOfSelectedItem) ?? .start
        refreshWrapFrame()
    }

    @objc private func onRunAlignmentChanged(_ sender: NSPopUpButton) {
        wrapView.runAlignment = NNWrapAlignment(rawValue: sender.indexOfSelectedItem) ?? .start
        refreshWrapFrame()
    }

    @objc private func onCrossAlignmentChanged(_ sender: NSPopUpButton) {
        wrapView.crossAxisAlignment = NNWrapCrossAlignment(rawValue: sender.indexOfSelectedItem) ?? .start
        refreshWrapFrame()
    }

    @objc private func onSpacingChanged(_ sender: NSTextField) {
        wrapView.spacing = CGFloat(sender.doubleValue)
        refreshWrapFrame()
    }

    @objc private func onRunSpacingChanged(_ sender: NSTextField) {
        wrapView.runSpacing = CGFloat(sender.doubleValue)
        refreshWrapFrame()
    }

    private func refreshWrapFrame() {
        view.needsLayout = true
        view.layoutSubtreeIfNeeded()
    }

    // MARK: - UI helpers

    private func makePopup(titles: [String], action: Selector) -> NSPopUpButton {
        let view = NSPopUpButton(frame: .zero, pullsDown: false)
        view.addItems(withTitles: titles)
        view.target = self
        view.action = action
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }

    private func makeNumberField(value: Int, action: Selector) -> NSTextField {
        let view = NSTextField(string: "\(value)")
        view.isEditable = true
        view.isBordered = true
        view.bezelStyle = .squareBezel
        view.alignment = .center
        view.font = NSFont.systemFont(ofSize: 12)
        view.target = self
        view.action = action
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return view
    }

    private func makeLabeledRow(_ title: String, _ control: NSView) -> NSView {
        let label = NSTextField(labelWithString: title)
        label.font = NSFont.systemFont(ofSize: 12)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.widthAnchor.constraint(equalToConstant: 130).isActive = true

        let row = NSStackView(views: [label, control])
        row.orientation = .horizontal
        row.alignment = .centerY
        row.spacing = 8
        row.distribution = .fill
        control.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return row
    }
}
