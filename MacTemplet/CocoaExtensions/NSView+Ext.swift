//
//  NSView+Ext.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/3/21.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import AppKit

extension NSView {

    /// 绘制边框曲线
    @objc func drawLineDashRect(_ rect: NSRect) {
        wantsLayer = true
        layer?.backgroundColor = NSColor.white.cgColor

        let path = NSBezierPath(rect: layer?.frame ?? rect)
        let dashPattern: [CGFloat] = [15.0, 10.0, 3.0, 10.0]
        path.lineWidth = 3.0
        path.lineCapStyle = .square
        path.setLineDash(dashPattern, count: dashPattern.count, phase: 0.0)
        NSColor.red.set()
        path.stroke()
    }
}
