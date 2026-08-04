//
//  NSImage+Ext.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/3/20.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import AppKit

extension NSImage {

    @objc(imageWithColor:)
    class func imageWithColor(_ color: NSColor) -> NSImage {
        let size = NSSize(width: 1.0, height: 1.0)
        let image = NSImage(size: size)
        image.lockFocus()
        color.drawSwatch(in: NSRect(x: 0, y: 0, width: size.width, height: size.height))
        image.unlockFocus()
        return image
    }

    @objc convenience init(color: NSColor) {
        self.init(size: NSSize(width: 1.0, height: 1.0))
        lockFocus()
        color.drawSwatch(in: NSRect(x: 0, y: 0, width: 1, height: 1))
        unlockFocus()
    }
}
