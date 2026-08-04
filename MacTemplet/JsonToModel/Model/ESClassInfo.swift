//
//  ESClassInfo.swift
//  ESJsonFormat
//
//  Created by 尹桥印 on 15/6/28.  Change by ZX on 17/5/17
//  Copyright (c) 2015年 EnjoySR. All rights reserved.
//

import AppKit
import Foundation
import SwiftExpand

@objcMembers
class ESClassInfo: NSObject {

    var modelName: String?
    var classNameKey: String?
    var classDic: [AnyHashable: Any]?
    var propertyClassDic = NSMutableDictionary()
    var propertyArrayDic = NSMutableDictionary()
    var langModel: NNLanguageModel?

    @objc(classWithKey:name:dic:)
    class func classWith(key: String, name className: String, dic classDic: [AnyHashable: Any]) -> ESClassInfo {
        return ESClassInfo(classNameKey: key, className: className, classDic: classDic)
    }

    @objc(initWithClassNameKey:className:classDic:)
    init(classNameKey: String, className: String, classDic: [AnyHashable: Any]) {
        super.init()
        self.classNameKey = classNameKey
        self.modelName = className
        self.classDic = classDic
    }

    var atClassArray: [Any] {
        let result = NSMutableArray()
        for case let classInfo as ESClassInfo in propertyClassDic.allValues {
            result.add(classInfo)
            result.addObjects(from: classInfo.atClassArray)
        }

        for case let classInfo as ESClassInfo in propertyArrayDic.allValues {
            if ESJsonFormatSetting.defaultSetting().useGeneric {
                result.add(classInfo)
            }
            result.addObjects(from: classInfo.atClassArray)
        }

        return result as! [Any]
    }

    var atClassContent: String {
        let atClassArray = self.atClassArray
        if atClassArray.count == 0 {
            return ""
        }

        let resultStr = NSMutableString(format: "@class ")
        for case let classInfo as ESClassInfo in atClassArray {
            resultStr.appendFormat("%@, ", classInfo.modelName ?? "")
        }

        if (resultStr as String).hasSuffix(", ") {
            resultStr.setString((resultStr as String).substring(to: (resultStr as String).index((resultStr as String).endIndex, offsetBy: -2)))
        }
        resultStr.append(";")
        return resultStr as String
    }

    var propertyContent: String {
        return ESJsonFormatManager.parsePropertyContent(withClassInfo: self)
    }

    var classContentForH: String {
        return ESJsonFormatManager.parseClassHeaderContent(withClassInfo: self)
    }

    var classContentForM: String {
        return ESJsonFormatManager.parseClassImpContent(withClassInfo: self)
    }

    var classInsertTextViewContentForH: String {
        let result = NSMutableString(string: "")
        for key in propertyClassDic.allKeys {
            guard let key = key as? String else { continue }
            let classInfo = propertyClassDic[key] as! ESClassInfo
            classInfo.langModel = langModel
            result.appendFormat("%@\n\n", classInfo.classContentForH)
            result.append(classInfo.classInsertTextViewContentForH)
        }

        for key in propertyArrayDic.allKeys {
            guard let key = key as? String else { continue }
            let classInfo = propertyArrayDic[key] as! ESClassInfo
            classInfo.langModel = langModel
            result.appendFormat("%@\n\n", classInfo.classContentForH)
            result.append(classInfo.classInsertTextViewContentForH)
        }
        return result as String
    }

    var classInsertTextViewContentForM: String {
        let result = NSMutableString(string: "")
        for key in propertyClassDic.allKeys {
            guard let key = key as? String else { continue }
            let classInfo = propertyClassDic[key] as! ESClassInfo
            classInfo.langModel = langModel
            result.appendFormat("%@\n\n", classInfo.classContentForM)
            result.append(classInfo.classInsertTextViewContentForM)
        }

        for key in propertyArrayDic.allKeys {
            guard let key = key as? String else { continue }
            let classInfo = propertyArrayDic[key] as! ESClassInfo
            classInfo.langModel = langModel
            result.appendFormat("%@\n\n", classInfo.classContentForM)
            result.append(classInfo.classInsertTextViewContentForM)
        }
        return result as String
    }

    @objc(createFileWithFolderPath:)
    func createFile(withFolderPath folderPath: String) {
        for key in propertyClassDic.allKeys {
            guard let key = key as? String else { continue }
            let classInfo = propertyClassDic[key] as! ESClassInfo
            classInfo.langModel = langModel
            classInfo.createFile(withFolderPath: folderPath)
        }

        for key in propertyArrayDic.allKeys {
            guard let key = key as? String else { continue }
            let classInfo = propertyArrayDic[key] as! ESClassInfo
            classInfo.langModel = langModel
            classInfo.createFile(withFolderPath: folderPath)
        }
        ESJsonFormatManager.createFile(withFolderPath: folderPath, classInfo: self)
    }

    @objc(dealWithJson:handler:)
    class func deal(withJson result: Any, handler: ((String?, String?) -> Void)?) -> ESClassInfo? {
        var classInfo: ESClassInfo?

        var rootClassName = UserDefaults.standard.string(forKey: kRootClass) ?? ""
        if rootClassName.isEmpty {
            rootClassName = ESRootClassName
        }

        if let dict = result as? [AnyHashable: Any] {
            if !ESJsonFormatSetting.defaultSetting().outputToFiles {
                let className = (UserDefaults.standard.object(forKey: kClassPrefix) as? String ?? "") + rootClassName
                classInfo = ESClassInfo.classWith(key: ESRootClassName, name: className, dic: dict)

                let isSwift = NSApplication.isSwift
                let hName = className + (isSwift ? ".swift" : ".h")
                let mName = className + (isSwift ? "" : ".m")
                handler?(hName, mName)
                classInfo = dealPropertyName(withClassInfo: classInfo!)
            } else {
                let className = (UserDefaults.standard.object(forKey: kClassPrefix) as? String ?? "") + rootClassName
                classInfo = ESClassInfo.classWith(key: ESRootClassName, name: className, dic: dict)
                classInfo = dealPropertyName(withClassInfo: classInfo!)
            }
        } else if let array = result as? [Any] {
            if ESJsonFormatSetting.defaultSetting().outputToFiles {
                let className = (UserDefaults.standard.object(forKey: kClassPrefix) as? String ?? "") + rootClassName
                let dic = [className: array]
                classInfo = ESClassInfo.classWith(key: ESRootClassName, name: className, dic: dic)
                classInfo = dealPropertyName(withClassInfo: classInfo!)
            } else {
                let className = (UserDefaults.standard.object(forKey: kClassPrefix) as? String ?? "") + rootClassName
                let dic = [className: array]
                classInfo = ESClassInfo.classWith(key: ESRootClassName, name: className, dic: dic)
                classInfo = dealPropertyName(withClassInfo: classInfo!)
            }
        }
        return classInfo
    }

    @objc(dealPropertyNameWithClassInfo:)
    class func dealPropertyName(withClassInfo classInfo: ESClassInfo) -> ESClassInfo {
        guard let dic = classInfo.classDic else { return classInfo }

        for key in dic.keys {
            guard let key = key as? String else { continue }
            let obj = dic[key]!

            if obj is [Any] || obj is [AnyHashable: Any] {
                if let array = obj as? [Any] {
                    if let first = array.first {
                        if !(first is [AnyHashable: Any] || first is [Any]) {
                            continue
                        }
                    }
                }

                var childClassName = (UserDefaults.standard.object(forKey: kClassPrefix) as? String ?? "") + (key as NSString).capitalized
                if !childClassName.contains("Model") {
                    childClassName = childClassName + "Model"
                }

                if let dict = obj as? [AnyHashable: Any] {
                    let childClassInfo = ESClassInfo.classWith(key: key, name: childClassName, dic: dict)
                    _ = dealPropertyName(withClassInfo: childClassInfo)
                    classInfo.propertyClassDic[key] = childClassInfo
                } else if let array = obj as? [Any] {
                    if let first = array.first as? [AnyHashable: Any] {
                        let childClassInfo = ESClassInfo.classWith(key: key, name: childClassName, dic: first)
                        _ = dealPropertyName(withClassInfo: childClassInfo)
                        classInfo.propertyArrayDic[key] = childClassInfo
                    }
                }
            }
        }
        return classInfo
    }

    @objc(classDescWithFirstFile:)
    func classDesc(withFirstFile isFirstFile: Bool) -> String? {
        let classInfo = self
        let dateStr = DateFormatter.stringFromDate(Date(), fmt: "yyyy/MM/dd")
        var modelStr = String(format: "//\n//Created by %@ on %@.\n//\n\n", NSApplication.userName, dateStr)
        modelStr = NSApplication.classCopyright

        if !NSApplication.isSwift {
            let hContent = String(format: "%@\n%@\n%@",
                                  classInfo.atClassContent,
                                  classInfo.classContentForH,
                                  classInfo.classInsertTextViewContentForH)
            let mContent = String(format: "%@\n%@",
                                  classInfo.classContentForM,
                                  classInfo.classInsertTextViewContentForM)

            let hImportStr = NSMutableString(string: "#import <Foundation/Foundation.h>\n\n")
            let superClassString = UserDefaults.standard.string(forKey: kSuperClass) ?? ""
            if !superClassString.isEmpty && superClassString != "NSObject" {
                hImportStr.appendFormat("#import \"%@.h\" \n\n", superClassString)
            }

            let mImportStr = String(format: "#import \"%@.h\"\n", classInfo.modelName ?? "")
            let finalHContent = String(format: "%@%@%@", modelStr, hImportStr, hContent)
            let finalMContent = String(format: "%@%@%@", modelStr, mImportStr, mContent)
            return isFirstFile ? finalHContent : finalMContent
        } else {
            let hContent = String(format: "%@\n\n%@",
                                  classInfo.classContentForH,
                                  classInfo.classInsertTextViewContentForH)
            let hImportStr = NSMutableString(string: "import Foundation\n\n")
            let finalHContent = String(format: "%@%@%@", modelStr, hImportStr, hContent)
            return finalHContent
        }
    }
}
