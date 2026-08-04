//
//  NSColor+Ext.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/3/23.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import AppKit

extension NSColor {

    @objc(nn_lightBlue)
    class var lightBlue: NSColor {
        return hexValue(0x29B5FE, alpha: 1)
    }

    @objc(nn_lightOrange)
    class var lightOrange: NSColor {
        return hexValue(0xFFBB50, alpha: 1)
    }

    @objc(nn_lightGreen)
    class var lightGreen: NSColor {
        return hexValue(0x1AC756, alpha: 1)
    }

    @objc(nn_line)
    class var line: NSColor {
        return hexValue(0xe4e4e4, alpha: 1)
    }

    @objc(hexValue:alpha:)
    class func hexValue(_ rgbValue: Int, alpha: CGFloat) -> NSColor {
        return NSColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0xFF) / 255.0,
            alpha: alpha
        )
    }
}
