//
//  NSTestViewController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/11/20.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SwiftExpand

@objcMembers class NSTestViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer?.backgroundColor = NSColor.lightGreen.cgColor

        let click = NSClickGestureRecognizer()
        view.addGestureRecognizer(click)

        click.addAction { _ in
        }
    }

    override func viewWillAppear() {
        super.viewWillAppear()
    }
}
