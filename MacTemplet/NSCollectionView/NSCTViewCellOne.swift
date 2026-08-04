//
//  NSCTViewCellOne.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/18.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftExpand

@objcMembers
class NSCTViewCellOne: NSCollectionViewItem {

    lazy var imgView: NSImageView = {
        let view = NSImageView.create(.zero)
        view.image = NSApplication.appIcon
        view.imageScaling = .scaleProportionallyDown
        return view
    }()

    lazy var label: NNTextField = {
        let view = NNTextField.create(.zero, placeholder: "简单介绍")
        view.isEditable = false
        view.font = NSFont.systemFont(ofSize: 12)
        view.alignment = .center
        view.isTextAlignmentVerticalCenter = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imgView)
        view.addSubview(label)

        imgView.layer?.backgroundColor = NSColor.green.cgColor
        label.layer?.backgroundColor = NSColor.yellow.cgColor
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        guard view.bounds.size.height > 0 else { return }

        let gap: CGFloat = 10
        let padding: CGFloat = 8

        imgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(gap)
            make.right.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(-30)
            make.height.equalTo(30).priority(.init(900))
        }

        label.snp.makeConstraints { make in
            make.bottom.equalTo(imgView.snp.bottom).offset(padding)
            make.right.equalToSuperview().offset(gap)
            make.left.equalToSuperview().offset(-gap)
            make.bottom.equalToSuperview().offset(-gap)
        }
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        guard representedObject != nil else { return }
    }

}
