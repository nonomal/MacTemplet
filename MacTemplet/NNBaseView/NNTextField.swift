//
//  NNTextField.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/11.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa

@objcMembers
class NNTextField: NSTextField {

    var isTextAlignmentVerticalCenter = false {
        didSet {
            (cell as? NNTextFieldCell)?.isTextAlignmentVerticalCenter = isTextAlignmentVerticalCenter
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        let textCell = NNTextFieldCell(textCell: "")
        textCell.lineBreakMode = .byWordWrapping
        textCell.truncatesLastVisibleLine = true
        cell = textCell
        isEditable = true
    }
}
