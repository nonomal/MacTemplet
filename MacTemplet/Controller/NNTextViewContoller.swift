//
//  NNTextViewContoller.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/26.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftExpand

@objcMembers class NNTextViewContoller: NSViewController {

    lazy var textView: NNTextView = {
        let view = NNTextView.create(.zero)
        view.delegate = self
        view.string = ""
        view.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
        return view
    }()

    lazy var slider: NSSlider = {
        let slider = NSSlider()
        slider.wantsLayer = true
        slider.layer?.backgroundColor = NSColor.lightGreen.cgColor
        slider.sliderType = .linear
        slider.tickMarkPosition = .above
        slider.numberOfTickMarks = 10
        slider.allowsTickMarkValuesOnly = true
        slider.target = self
        slider.action = #selector(handleActionSlider(_:))
        return slider
    }()

    lazy var sliderOne: NSSlider = {
        let slider = NSSlider()
        slider.wantsLayer = true
        slider.layer?.backgroundColor = NSColor.lightGreen.cgColor
        slider.sliderType = .circular
        slider.tickMarkPosition = .above
        slider.numberOfTickMarks = 10
        slider.allowsTickMarkValuesOnly = true
        slider.target = self
        slider.action = #selector(handleActionSlider(_:))
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView.enclosingScrollView!)
        NoodleLineNumberView.setupLineNumber(with: textView)
        view.addSubview(slider)
        view.addSubview(sliderOne)
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        textView.enclosingScrollView!.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kX_GAP)
            make.left.equalToSuperview().offset(kX_GAP)
            make.width.equalTo(400)
            make.bottom.equalToSuperview().offset(-kX_GAP)
        }

        slider.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kX_GAP)
            make.left.equalTo(textView.enclosingScrollView!.snp.right).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }

        sliderOne.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kX_GAP)
            make.left.equalTo(slider.snp.right).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }

    @objc func handleActionSlider(_ sender: NSSlider) {
        let value = sender.floatValue
        NSLog("sliderAction value： %f", value)
    }
}

extension NNTextViewContoller: NSTextViewDelegate, NSControlTextEditingDelegate {

    func controlTextDidBeginEditing(_ obj: Notification) {
        // print("开始编辑")
    }

    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        DDLog(textField.stringValue)
    }

    func controlTextDidEndEditing(_ obj: Notification) {
        // guard let textField = obj.object as? NSTextField else { return }
        // DDLog(textField.stringValue)
    }

    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        NSLog("Selector method is (%@)", NSStringFromSelector(commandSelector))
        if commandSelector == #selector(insertNewline(_:)) {
            // Do something against ENTER key
        } else if commandSelector == #selector(deleteForward(_:)) {
            // Do something against DELETE key
        } else if commandSelector == #selector(deleteBackward(_:)) {
            // Do something against BACKSPACE key
        } else if commandSelector == #selector(insertTab(_:)) {
            // Do something against TAB key
        } else if commandSelector == #selector(cancelOperation(_:)) {
            // Do something against Escape key
        }
        return true
    }
}
