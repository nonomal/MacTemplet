//
//  NSApplication+Ext.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/2/3.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import AppKit

extension NSApplication {

    @objc static var isSwift: Bool {
        get {
            UserDefaults.standard.bool(forKey: "kIsSwift")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "kIsSwift")
            UserDefaults.standard.synchronize()
        }
    }
}
