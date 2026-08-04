//
//  NNAttStringKey.swift
//  ProductTemplet
//
//  Created by hsf on 2018/8/30.
//  Copyright © 2018年 BN. All rights reserved.
//

import Foundation

@objcMembers
class NNAttStringKey: NSObject {

    private static var _obj: String?
    private static var _title: String?
    private static var _font: String?
    private static var _textColor: String?
    private static var _textColor_H: String?
    private static var _imgName: String?
    private static var _imgName_H: String?
    private static var _controlName: String?
    private static var _backgroundColor: String?

    class var obj: String {
        if _obj == nil { _obj = "obj" }
        return _obj!
    }

    class var title: String {
        if _title == nil { _title = "title" }
        return _title!
    }

    class var font: String {
        if _font == nil { _font = "font" }
        return _font!
    }

    class var textColor: String {
        if _textColor == nil { _textColor = "textColor" }
        return _textColor!
    }

    class var textColor_H: String {
        if _textColor_H == nil { _textColor_H = "textColor_H" }
        return _textColor_H!
    }

    class var imgName: String {
        if _imgName == nil { _imgName = "imgName" }
        return _imgName!
    }

    class var imgName_H: String {
        if _imgName_H == nil { _imgName_H = "imgName_H" }
        return _imgName_H!
    }

    class var controlName: String {
        if _controlName == nil { _controlName = "controlName" }
        return _controlName!
    }

    class var backgroundColor: String {
        if _backgroundColor == nil { _backgroundColor = "backgroundColor" }
        return _backgroundColor!
    }
}
