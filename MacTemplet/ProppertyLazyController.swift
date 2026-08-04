//
//  ProppertyLazyController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/26.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SnapKitExtend
import SwiftExpand

@objcMembers class ProppertyLazyController: NSViewController {

    var btnItems: [String] = []

    lazy var textLabel: HHLabel = {
        let view = HHLabel(frame: .zero)
        view.isBordered = false
        view.font = NSFont.systemFont(ofSize: 13)
        view.textColor = NSColor.systemGreen
        view.alignment = .center
        view.maximumNumberOfLines = 1
        view.usesSingleLineMode = true
        view.backgroundColor = NSColor.clear
        view.mouseDownBlock = { _ in
        }
        return view
    }()

    lazy var textView: NNTextView = {
        let view = NNTextView.create(.zero)
        view.delegate = self
        view.string = ""
        view.font = NSFont.systemFont(ofSize: 12)
        return view
    }()

    lazy var textViewOne: NNTextView = {
        let view = NNTextView.create(.zero)
        view.string = ""
        view.font = NSFont.systemFont(ofSize: 12)
        return view
    }()

    lazy var bottomView: NNView = {
        let view = NNView()
        for i in 0..<btnItems.count {
            let btn = NSButton()
            btn.bezelStyle = .regularSquare
            btn.title = btnItems[i]
            btn.tag = i
            btn.target = self
            btn.action = #selector(p_handleAction(_:))
            btn.sendAction(on: .otherMouseUp)
            view.addSubview(btn)
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.stringValue = "此处文本框显示的效果和 XCode(Version 11.1 (11A1027))显示效果有差异, 以 XCode 实际效果为准"
        btnItems = ["属性Lazy", "Copy"]

        view.addSubview(textView.enclosingScrollView!)
        view.addSubview(textViewOne.enclosingScrollView!)
        view.addSubview(bottomView)
        view.addSubview(textLabel)

        NoodleLineNumberView.setupLineNumber(with: textView)

        textView.string = """

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSMutableString *mstr;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *btn;
@property (class, nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *subject_typeDic;
"""

        textView.resignFirstResponder()
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        let list = [textView.enclosingScrollView!, textViewOne.enclosingScrollView!]
        list.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 15, leadSpacing: 0, tailSpacing: 0)
        list.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }

        bottomView.snp.makeConstraints { make in
            make.top.equalTo(textView.enclosingScrollView!.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        let btns = bottomView.subviews
        btns.snp.distributeViewsAlong(axisType: .horizontal, fixedItemLength: 100, leadSpacing: 10, tailSpacing: 10)
        btns.snp.makeConstraints { make in
            make.top.equalTo(bottomView).offset(kY_GAP)
            make.bottom.equalTo(bottomView).offset(-kY_GAP)
        }

        textLabel.sizeToFit()
        textLabel.center = bottomView.center
    }

    func createResult(_ string: String) -> String {
        let list = NNPropertyModel.models(with: string)
        let mStr = NSMutableString()
        for model in list {
            mStr.appendFormat("%@\n", model.lazyDes)
        }
        return mStr as String
    }

    func showConvertResult() {
        if !textView.string.contains("*") {
            NSAlert(title: "提示", message: "❌lazy属性必须包含*", btnTitles: [kTitleKnow], style: .informational).runModal()
            return
        }
        NSApp.keyWindow?.makeFirstResponder(nil)
        textViewOne.string = createResult(textView.string)
    }

    @IBAction func showAlert(_ sender: Any?) {
    }

    func p_handleAction(_ sender: NSButton) {
        switch sender.tag {
        case 0:
            showConvertResult()
        case 1:
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(textViewOne.string, forType: .string)
        default:
            break
        }
    }
}

extension ProppertyLazyController: NSTextViewDelegate {

    func textShouldBeginEditing(_ textObject: NSText) -> Bool {
        return true
    }

    func textDidEndEditing(_ notification: Notification) {
        showConvertResult()
    }

    func textDidChange(_ notification: Notification) {
        showConvertResult()
    }
}
