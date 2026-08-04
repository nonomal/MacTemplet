//
//  NNDatePickerController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/19.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftExpand

@objcMembers class NNDatePickerController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer?.backgroundColor = NSColor.lightGreen.cgColor

        view.addSubview(datePicker)
        view.addSubview(imageView)
        view.addSubview(btn)
        view.addSubview(btnCancell)
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        datePicker.snp.makeConstraints { make in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view).offset(20)
        }

        imageView.snp.makeConstraints { make in
            make.left.equalTo(datePicker.snp.right).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.bottom.equalTo(datePicker).offset(0)
        }

        btn.snp.makeConstraints { make in
            make.left.equalTo(view).offset(20)
            make.bottom.equalTo(view).offset(-20)
            make.size.equalTo(CGSize(width: 80, height: 35))
        }

        btnCancell.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-20)
            make.size.equalTo(CGSize(width: 80, height: 35))
        }
    }

    // MARK: - funtions

    @objc func handleActionImgView(_ sender: NSImageView) {
    }

    // MARK: - lazy

    lazy var datePicker: NSDatePicker = {
        let view = NSDatePicker()
        view.datePickerStyle = .clockAndCalendar
        view.layer?.backgroundColor = NSColor.white.cgColor
        view.dateValue = Date()
        view.addActionHandler { control in
            guard let sender = control as? NSDatePicker else { return }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            DDLog(formatter.string(from: sender.dateValue))
        }
        return view
    }()

    lazy var imageView: NSImageView = {
        let view = NSImageView(frame: .zero)
        view.wantsLayer = true
        view.imageAlignment = .alignCenter
        view.imageFrameStyle = .none
        view.isEditable = true
        view.allowsCutCopyPaste = true
        view.imageScaling = .scaleAxesIndependently
        view.animates = true
        view.canDrawSubviewsIntoLayer = true
        view.image = NSImage(named: "timg.gif")
        view.target = self
        view.action = #selector(handleActionImgView(_:))
        return view
    }()

    lazy var btn: NSButton = {
        let view = NSButton()
        view.title = "确定"
        view.bezelStyle = .regularSquare
        view.addActionHandler { control in
            guard let sender = control as? NSButton else { return }
            DDLog(sender.title)
            NSApp.keyWindow?.endSheet(self.view.window!, returnCode: .OK)
        }
        return view
    }()

    lazy var btnCancell: NSButton = {
        let view = NSButton()
        view.title = "取消"
        view.bezelStyle = .regularSquare
        view.addActionHandler { control in
            guard let sender = control as? NSButton else { return }
            DDLog(sender.title)
            NSApp.keyWindow?.endSheet(self.view.window!, returnCode: .cancel)
        }
        return view
    }()
}
