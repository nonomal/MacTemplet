//
//  AuthorInfoController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/27.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftExpand

@objcMembers class AuthorInfoController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imgView)
        view.addSubview(textField)
        view.addSubview(textFieldOne)
        view.addSubview(textView)

        textFieldOne.isHidden = true
        textView.isHidden = true

        let dic: [String: String] = [
            "github/shang1219178163": "https://github.com/shang1219178163"
        ]

        let infoText = "\(NSApplication.appName)\n\(NSApplication.appCopyright)\ngithub/shang1219178163"

        textField.stringValue = infoText
        textField.hyperlink(dic: dic)

        textFieldOne.stringValue = infoText
        textFieldOne.hyperlink(dic: dic)

        textView.string = infoText
        textView.hyperlink(dic: dic)
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        imgView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(30)
            make.left.equalTo(view).offset(30)
            make.width.height.equalTo(70)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(imgView).offset(0)
            make.left.equalTo(imgView.snp.right).offset(kX_GAP)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(80)
        }

        textFieldOne.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(kPadding)
            make.left.equalTo(textField).offset(0)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(80)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(textFieldOne.snp.bottom).offset(kPadding)
            make.left.equalTo(textField).offset(0)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(80)
        }
    }

    override func viewWillAppear() {
        super.viewWillAppear()
    }

    func showAlert() {
        let title = "This is messageText"
        let message = "NSWarningAlertStyle \rDo you want to continue with delete of selected records"
        let list = ["continue", "cancle"]
        let alert = NSAlert(title: title, message: message, btnTitles: list, style: .informational)
        alert.beginSheetModal(for: NSApplication.shared.mainWindow!) { returnCode in
            if returnCode == .OK {
                DDLog("(returnCode == NSOKButton)")
            } else if returnCode == .cancel {
                DDLog("(returnCode == NSCancelButton)")
            } else if returnCode == .alertFirstButtonReturn {
                DDLog("if (returnCode == NSAlertFirstButtonReturn)")
            } else if returnCode == .alertSecondButtonReturn {
                DDLog("else if (returnCode == NSAlertSecondButtonReturn)")
            } else if returnCode == .alertThirdButtonReturn {
                DDLog("else if (returnCode == NSAlertThirdButtonReturn)")
            } else {
                DDLog("All Other return code \(returnCode.rawValue)")
            }
        }
    }

    // MARK: - lazy

    lazy var imgView: NSImageView = {
        let view = NSImageView.create(.zero)
        view.wantsLayer = true
        view.imageAlignment = .alignCenter
        view.imageFrameStyle = .none
        view.imageScaling = .scaleAxesIndependently
        view.isEditable = true
        view.allowsCutCopyPaste = true
        view.animates = true
        view.canDrawSubviewsIntoLayer = true
        view.image = NSApplication.appIcon
        view.image = NSImage(named: "timg.gif")
        return view
    }()

    lazy var textField: NNTextField = {
        let view = NNTextField.create(.zero, placeholder: "简单介绍")
        view.cell?.isScrollable = true
        view.cell?.wraps = true
        view.font = NSFont(name: "PingFangSC-Light", size: 14)
        view.isEditable = false
        view.isSelectable = true
        view.allowsEditingTextAttributes = true
        return view
    }()

    lazy var textFieldOne: NSTextField = {
        let view = NSTextField()
        view.cell?.isScrollable = true
        view.font = NSFont(name: "PingFangSC-Light", size: 14)
        view.cell?.wraps = true
        view.isEditable = false
        view.isSelectable = true
        view.allowsEditingTextAttributes = true
        return view
    }()

    lazy var textView: NNTextView = {
        let view = NNTextView.create(.zero)
        view.string = ""
        view.font = NSFont(name: "PingFangSC-Light", size: 14)
        view.isEditable = false
        view.isSelectable = true
        return view
    }()
}
