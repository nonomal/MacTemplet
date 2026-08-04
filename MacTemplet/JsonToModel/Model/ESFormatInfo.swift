//
//  ESFormatInfo.swift
//  ESJsonFormat
//

import Foundation

@objcMembers
class ESFormatInfo: NSObject {
    var pasteboardContent: String?
    var writeToMContent: String?
    var rootClassImplementMethodOfMJExtensionContent: String?

    lazy var classInfos: NSMutableArray = NSMutableArray()

    /// 内容，用于在不创建文件的模式下使用。
    var atClassContent: String? {
        guard classInfos.count > 0 else { return nil }
        guard let first = classInfos.firstObject as? ESClassInfo else { return nil }
        let resultStr = NSMutableString(format: "\n@class %@", first.modelName ?? "")
        for i in 0..<(classInfos.count - 1) {
            guard let info = classInfos[i + 1] as? ESClassInfo else { continue }
            resultStr.appendFormat(",%@", info.modelName ?? "")
        }
        resultStr.append(";")
        return resultStr as String
    }
}
