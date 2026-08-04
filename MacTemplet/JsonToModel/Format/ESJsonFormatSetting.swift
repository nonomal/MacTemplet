//
//  ESJsonFormatSetting.swift
//  ESJsonFormat
//
//  Created by 尹桥印 on 15/7/19.  Change by ZX on 17/5/17
//  Copyright (c) 2015年 EnjoySR. All rights reserved.
//

import Foundation

let kESJsonFormatGeneric = "com.EnjoySR.ESJsonFormat.Generic"
let kESJsonFormatOutputToFiles = "com.EnjoySR.ESJsonFormat.OutputToFiles"
let kESJsonFormatImpObjClassInArray = "com.EnjoySR.ESJsonFormat.ImpObjClassInArray"
let kESJsonFormatUppercaseKeyWordForId = "com.EnjoySR.ESJsonFormat.UppercaseKeyWordForId"

@objcMembers
class ESJsonFormatSetting: NSObject {

    private static let _defaultSetting: ESJsonFormatSetting = {
        let defaultSetting = ESJsonFormatSetting()
        let defaults: [String: Any] = [
            kESJsonFormatGeneric: true,
            kESJsonFormatOutputToFiles: false,
            kESJsonFormatImpObjClassInArray: true,
            kESJsonFormatUppercaseKeyWordForId: true
        ]
        UserDefaults.standard.register(defaults: defaults)
        return defaultSetting
    }()

    @objc(defaultSetting)
    class func defaultSetting() -> ESJsonFormatSetting {
        return _defaultSetting
    }

    var useGeneric: Bool {
        get { UserDefaults.standard.bool(forKey: kESJsonFormatGeneric) }
        set {
            UserDefaults.standard.set(newValue, forKey: kESJsonFormatGeneric)
            UserDefaults.standard.synchronize()
        }
    }

    var impOjbClassInArray: Bool {
        get { UserDefaults.standard.bool(forKey: kESJsonFormatImpObjClassInArray) }
        set {
            UserDefaults.standard.set(newValue, forKey: kESJsonFormatImpObjClassInArray)
            UserDefaults.standard.synchronize()
        }
    }

    var outputToFiles: Bool {
        get { UserDefaults.standard.bool(forKey: kESJsonFormatOutputToFiles) }
        set {
            UserDefaults.standard.set(newValue, forKey: kESJsonFormatOutputToFiles)
            UserDefaults.standard.synchronize()
        }
    }

    var uppercaseKeyWordForId: Bool {
        get { UserDefaults.standard.bool(forKey: kESJsonFormatUppercaseKeyWordForId) }
        set {
            UserDefaults.standard.set(newValue, forKey: kESJsonFormatUppercaseKeyWordForId)
            UserDefaults.standard.synchronize()
        }
    }
}
