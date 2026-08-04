//
//  ESJsonFormatManager.swift
//  ESJsonFormat
//
//  Created by 尹桥印 on 15/6/28. Change by ZX on 17/5/17
//  Copyright (c) 2015年 EnjoySR. All rights reserved.
//

import AppKit
import Foundation
import SwiftExpand

@objcMembers
class ESJsonFormatManager: NSObject {

    @objc(parsePropertyContentWithClassInfo:)
    class func parsePropertyContent(withClassInfo classInfo: ESClassInfo) -> String {
        let resultStr = NSMutableString()
        let dic = classInfo.classDic ?? [:]
        let list = dic.keys.sorted(by: { ($0 as! String).compare($1 as! String) == .orderedAscending })

        for key in list {
            guard let key = key as? String else { continue }
            guard let obj = dic[key] else { continue }
            if NSApplication.isSwift {
                resultStr.appendFormat("\n%@\n", formatSwift(withKey: key, value: obj, classInfo: classInfo))
            } else {
                resultStr.appendFormat("\n%@\n", formatObjc(withKey: key, value: obj, classInfo: classInfo))
            }
        }
        return resultStr as String
    }

    private class func isJSONBool(_ value: Any) -> Bool {
        if value is Bool { return true }
        if let obj = value as? NSObject, CFGetTypeID(obj) == CFBooleanGetTypeID() { return true }
        return false
    }

    /**
     *  格式化OC属性字符串
     */
    private class func formatObjc(withKey key: String, value: Any, classInfo: ESClassInfo) -> String {
        var key = key
        var qualifierStr = "copy"
        var typeStr = "NSString"

        if (classInfo.langModel?.reservedKeywords as? [String])?.contains(key) == true,
           ESJsonFormatSetting.defaultSetting().uppercaseKeyWordForId {
            key = key + "New"
        }

        if value is String {
            return String(format: "@property (nonatomic, %@) %@ *%@;", qualifierStr, typeStr, key)
        } else if isJSONBool(value) {
            qualifierStr = "assign"
            typeStr = "BOOL"
            return String(format: "@property (nonatomic, %@) %@ %@;", qualifierStr, typeStr, key)
        } else if let number = value as? NSNumber {
            let valueStr = "\(number)"
            if valueStr.range(of: ".") != nil {
                typeStr = "CGFloat"
            } else {
                if number.intValue < 2147483648 {
                    typeStr = "NSInteger"
                } else {
                    typeStr = "long long"
                }
            }
            return String(format: "@property (nonatomic, %@) %@ %@;", qualifierStr, typeStr, key)
        } else if let array = value as? [Any] {
            var genericTypeStr = ""
            if let firstObj = array.first {
                if firstObj is [AnyHashable: Any] {
                    let childInfo = classInfo.propertyArrayDic[key] as? ESClassInfo
                    genericTypeStr = String(format: "<%@ *>", childInfo?.modelName ?? "")
                } else if firstObj is String {
                    genericTypeStr = "<NSString *>"
                } else if firstObj is NSNumber {
                    genericTypeStr = "<NSNumber *>"
                }
            }

            qualifierStr = "strong"
            typeStr = "NSArray"
            if ESJsonFormatSetting.defaultSetting().useGeneric {
                return String(format: "@property (nonatomic, %@) %@%@ *%@;", qualifierStr, typeStr, genericTypeStr, key)
            }
            return String(format: "@property (nonatomic, %@) %@ *%@;", qualifierStr, typeStr, key)
        } else if value is [AnyHashable: Any] {
            qualifierStr = "strong"
            let childInfo = classInfo.propertyClassDic[key] as? ESClassInfo
            typeStr = childInfo?.modelName ?? (key as NSString).capitalized
            return String(format: "@property (nonatomic, %@) %@ *%@;", qualifierStr, typeStr, key)
        }
        return String(format: "@property (nonatomic, %@) %@ *%@;", qualifierStr, typeStr, key)
    }

    /**
     *  格式化Swift属性字符串
     */
    private class func formatSwift(withKey key: String, value: Any, classInfo: ESClassInfo) -> String {
        var key = key
        var typeStr = "String = \"\""

        if (classInfo.langModel?.reservedKeywords as? [String])?.contains(key) == true,
           ESJsonFormatSetting.defaultSetting().uppercaseKeyWordForId {
            key = key + "New"
        }

        if value is String {
            return String(format: "    var %@: %@", key, typeStr)
        } else if isJSONBool(value) {
            typeStr = "Bool"
            return String(format: "    var %@: %@ = false", key, typeStr)
        } else if let number = value as? NSNumber {
            let valueStr = "\(number)"
            if valueStr.range(of: ".") != nil {
                typeStr = "Double"
            } else {
                typeStr = "Int"
            }
            return String(format: "    var %@: %@ = 0", key, typeStr)
        } else if value is [Any] {
            let childInfo = classInfo.propertyArrayDic[key] as? ESClassInfo
            let type = childInfo?.modelName
            return String(format: "    var %@: [%@] = []", key, type ?? "String")
        } else if value is [AnyHashable: Any] {
            let childInfo = classInfo.propertyClassDic[key] as? ESClassInfo
            typeStr = childInfo?.modelName ?? (key as NSString).capitalized
            return String(format: "    var %@: %@?", key, typeStr)
        }
        return String(format: "    var %@: %@", key, typeStr)
    }

    @objc(parseClassHeaderContentWithClassInfo:)
    class func parseClassHeaderContent(withClassInfo classInfo: ESClassInfo) -> String {
        if NSApplication.isSwift {
            return parseClassContentForSwift(withClassInfo: classInfo)
        } else {
            return parseClassHeaderContentForOjbc(withClassInfo: classInfo)
        }
    }

    @objc(parseClassImpContentWithClassInfo:)
    class func parseClassImpContent(withClassInfo classInfo: ESClassInfo) -> String {
        if NSApplication.isSwift {
            return ""
        }

        var result = NSMutableString(string: "")
        if ESJsonFormatSetting.defaultSetting().impOjbClassInArray {
            result.appendFormat("\n@implementation %@\n%@\n%@\n@end\n",
                                classInfo.modelName ?? "",
                                methodContentOfObjectClassInArray(withClassInfo: classInfo),
                                methodContentOfObjectIDInArray(withClassInfo: classInfo))
        } else {
            result.appendFormat("@implementation %@\n\n@end\n", classInfo.modelName ?? "")
        }

        if ESJsonFormatSetting.defaultSetting().outputToFiles {
            let headerString = NSMutableString(string: dealHeaderStr(withClassInfo: classInfo, type: "m"))
            headerString.appendFormat("#import \"%@.h\"\n", classInfo.modelName ?? "")
            for key in classInfo.propertyArrayDic.allKeys {
                guard let key = key as? String else { continue }
                let childClassInfo = classInfo.propertyArrayDic[key] as! ESClassInfo
                headerString.appendFormat("#import \"%@.h\"\n", childClassInfo.modelName ?? "")
            }
            headerString.append("\n")
            result.insert(headerString as String, at: 0)
        }
        return result as String
    }

    /**
     *  解析.h文件内容--Objc
     */
    private class func parseClassHeaderContentForOjbc(withClassInfo classInfo: ESClassInfo) -> String {
        var superClassString = UserDefaults.standard.string(forKey: kSuperClass) ?? ""
        superClassString = superClassString.isEmpty ? "NSObject" : superClassString

        let result = NSMutableString(format: "\n\n@interface %@ : %@\n", classInfo.modelName ?? "", superClassString)
        result.append(classInfo.propertyContent ?? "")
        result.append("\n@end")

        if ESJsonFormatSetting.defaultSetting().outputToFiles {
            let headerString = NSMutableString(string: dealHeaderStr(withClassInfo: classInfo, type: "h"))
            headerString.appendFormat("%@\n\n", classInfo.atClassContent ?? "")
            result.insert(headerString as String, at: 0)
        }
        return result as String
    }

    /**
     *  解析.swift文件内容--Swift
     */
    private class func parseClassContentForSwift(withClassInfo classInfo: ESClassInfo) -> String {
        var superClassString = UserDefaults.standard.string(forKey: kSuperClass) ?? ""
        superClassString = superClassString.isEmpty ? "NSObject" : superClassString

        let result = NSMutableString(format: "@objcMembers class %@: %@, %@ {\n",
                                     classInfo.modelName ?? "",
                                     superClassString,
                                     classInfo.langModel?.podName ?? "")
        result.append(classInfo.propertyContent ?? "")

        let constructors = (classInfo.langModel?.constructors as? [String])?.joined(separator: "\n") ?? ""
        result.appendFormat("\n    %@", constructors)
        result.appendFormat("\n    %@", methodContentOfSwiftMapMethod(withClassInfo: classInfo))
        result.appendFormat("\n    %@", methodContentOfSwiftObjectClassInArray(withClassInfo: classInfo))

        result.append("\n}")
        if ESJsonFormatSetting.defaultSetting().outputToFiles {
            result.insert("import Cocoa\n\n", at: 0)
            let headerString = dealHeaderStr(withClassInfo: classInfo, type: "swift")
            result.insert(headerString, at: 0)
        }
        return result as String
    }

    private class func methodContentOfSwiftObjectClassInArray(withClassInfo classInfo: ESClassInfo) -> String {
        if classInfo.propertyArrayDic.count == 0 {
            return ""
        }

        let result = NSMutableString()
        for key in classInfo.propertyArrayDic.allKeys {
            guard let key = key as? String else { continue }
            let childClassInfo = classInfo.propertyArrayDic[key] as! ESClassInfo
            result.appendFormat("\"%@\" : %@.self,\n\t\t\t\t", key, childClassInfo.modelName ?? "")
        }
        if (result as String).hasSuffix(", ") {
            result.setString((result as String).substring(to: (result as String).index((result as String).endIndex, offsetBy: -2)))
        }

        let utilityMethodsModel = classInfo.langModel?.utilityMethods?.first
        guard let propertyMapModelMethod = utilityMethodsModel?.propertyMapModelMethod else {
            return ""
        }
        return propertyMapModelMethod.replacingOccurrences(of: "%@", with: result as String)
    }

    private class func methodContentOfSwiftMapMethod(withClassInfo classInfo: ESClassInfo) -> String {
        let podName = classInfo.langModel?.podName ?? ""
        let result = NSMutableString()
        let keys = classInfo.propertyArrayDic.allKeys.count > 0
            ? classInfo.propertyArrayDic.allKeys
            : (classInfo.classDic?.keys.map { $0 as Any } ?? [])

        for key in keys {
            guard let key = key as? String else { continue }
            if (classInfo.langModel?.reservedKeywords as? [String])?.contains(key) == true {
                if podName == "HandyJSON" {
                    result.appendFormat("\t\tmapper <<< %@New <-- \"%@\";\n", key, key)
                } else if podName == "YYModel" {
                    result.appendFormat("\"%@New\":   \"%@\",\n\t\t\t\t", key, key)
                }
            }
        }

        if (result as String).hasSuffix(";") {
            result.setString((result as String).substring(to: (result as String).index((result as String).endIndex, offsetBy: -2)))
        }

        if podName == "YYModel" && result.length == 0 {
            result.append(":")
        }

        let utilityMethodsModel = classInfo.langModel?.utilityMethods?.first
        let propertyMapPropertyMethod = utilityMethodsModel?.propertyMapPropertyMethod ?? ""
        return propertyMapPropertyMethod.replacingOccurrences(of: "%@", with: result as String)
    }

    /**
     *  生成 MJExtension 的集合中指定对象的方法
     */
    @objc(methodContentOfObjectClassInArrayWithClassInfo:)
    class func methodContentOfObjectClassInArray(withClassInfo classInfo: ESClassInfo) -> String {
        if classInfo.propertyArrayDic.count == 0 {
            return ""
        }

        let result = NSMutableString()
        for key in classInfo.propertyArrayDic.allKeys {
            guard let key = key as? String else { continue }
            let childClassInfo = classInfo.propertyArrayDic[key] as! ESClassInfo
            result.appendFormat("@\"%@\" : [%@ class],\n\t\t", key, childClassInfo.modelName ?? "")
        }
        if (result as String).hasSuffix(", ") {
            result.setString((result as String).substring(to: (result as String).index((result as String).endIndex, offsetBy: -2)))
        }

        let utilityMethodsModel = classInfo.langModel?.utilityMethods?.first
        let propertyMapModelMethod = utilityMethodsModel?.propertyMapModelMethod ?? ""
        return propertyMapModelMethod.replacingOccurrences(of: "%@", with: result as String)
    }

    private class func methodContentOfObjectIDInArray(withClassInfo classInfo: ESClassInfo) -> String {
        let result = NSMutableString()
        guard let dic = classInfo.classDic else { return result as String }

        for (key, obj) in dic {
            guard let key = key as? String else { continue }
            if (classInfo.langModel?.reservedKeywords as? [String])?.contains(key) == true,
               ESJsonFormatSetting.defaultSetting().uppercaseKeyWordForId {
                result.appendFormat("@\"%@New\": @\"%@\", ", key, key)
            }
            _ = obj
        }

        if (result as String).hasSuffix(", ") {
            result.setString((result as String).substring(to: (result as String).index((result as String).endIndex, offsetBy: -2)))
            let utilityMethodsModel = classInfo.langModel?.utilityMethods?.first
            let propertyMapPropertyMethod = utilityMethodsModel?.propertyMapPropertyMethod ?? ""
            return propertyMapPropertyMethod.replacingOccurrences(of: "%@", with: result as String)
        }
        return result as String
    }

    /**
     *  拼装模板信息
     */
    private class func dealHeaderStr(withClassInfo classInfo: ESClassInfo, type: String) -> String {
        let path = Bundle.main.path(forResource: "DataModelsTemplate", ofType: "txt")
        var templateString = (try? String(contentsOfFile: path ?? "", encoding: .utf8)) ?? ""

        templateString = templateString.replacingOccurrences(of: "__MODELNAME__",
                                                             with: String(format: "%@.%@", classInfo.modelName ?? "", type))
        templateString = templateString.replacingOccurrences(of: "__NAME__", with: NSFullUserName())
        let productName = ESPbxprojInfo.share().productName
        if !productName.isEmpty {
            templateString = templateString.replacingOccurrences(of: "__PRODUCTNAME__", with: productName)
        }
        let organizationName = ESPbxprojInfo.share().organizationName
        if !organizationName.isEmpty {
            templateString = templateString.replacingOccurrences(of: "__ORGANIZATIONNAME__", with: organizationName)
        }
        let dateStr = DateFormatter.stringFromDate(Date(), fmt: "yy/MM/dd")
        templateString = templateString.replacingOccurrences(of: "__DATE__", with: dateStr)

        if type == "h" || type == "swift" {
            var string = templateString
            if type == "h" {
                string += "#import <Foundation/Foundation.h>\n\n"
                let superClassString = UserDefaults.standard.string(forKey: kSuperClass) ?? ""
                if !superClassString.isEmpty {
                    string += String(format: "#import \"%@.h\" \n\n", superClassString)
                }
            } else {
                string += "import Foundation\n\n"
                let superClassString = UserDefaults.standard.string(forKey: kSuperClass) ?? ""
                if !superClassString.isEmpty {
                    string += String(format: "import %@ \n\n", superClassString)
                }
            }
            templateString = string
        }
        return templateString
    }

    @objc(createFileWithFolderPath:classInfo:)
    class func createFile(withFolderPath folderPath: String, classInfo: ESClassInfo) {
        if !NSApplication.isSwift {
            let hFilename = String(format: "%@.h", classInfo.modelName ?? "")
            FileManager.createFile(atPath: folderPath, name: hFilename, content: classInfo.classContentForH ?? "", attributes: nil, isCover: true)

            let mFilename = String(format: "%@.m", classInfo.modelName ?? "")
            FileManager.createFile(atPath: folderPath, name: mFilename, content: classInfo.classContentForM ?? "", attributes: nil, isCover: true)
        } else {
            let hFilename = String(format: "%@.swift", classInfo.modelName ?? "")
            FileManager.createFile(atPath: folderPath, name: hFilename, content: classInfo.classContentForH ?? "", attributes: nil, isCover: true)
        }
    }
}
