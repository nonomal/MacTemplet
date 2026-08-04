//
//  ESPbxprojInfo.swift
//  ESJsonFormat
//

import Foundation

@objcMembers
class ESPbxprojInfo: NSObject {
    private(set) var classPrefix: String = ""
    private(set) var organizationName: String = ""
    private(set) var productName: String = ""

    private static let sharedInstance = ESPbxprojInfo()

    @objc(shareInstance)
    class func share() -> ESPbxprojInfo {
        return sharedInstance
    }

    @objc(setParamsWithPath:)
    func setParams(withPath path: String) {
        guard let pbxprojData = NSData(contentsOfFile: path) as Data?,
              let pbxprojStr = String(data: pbxprojData, encoding: .utf8) else {
            return
        }
        classPrefix = matchString(withKeyWord: "CLASSPREFIX", matchIn: pbxprojStr)
        organizationName = matchString(withKeyWord: "ORGANIZATIONNAME", matchIn: pbxprojStr)
        productName = matchString(withKeyWord: "productName", matchIn: pbxprojStr)
    }

    private func matchString(withKeyWord keyWord: String, matchIn matchString: String) -> String {
        var resultStr = ""
        let prefixStr = "\(keyWord) = "
        let pattern = "\(prefixStr)[a-zA-Z0-9\\u4e00-\\u9fa5]+;"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return resultStr
        }
        let range = NSRange(location: 0, length: (matchString as NSString).length)
        if let match = regex.firstMatch(in: matchString, options: [], range: range) {
            let result = (matchString as NSString).substring(with: match.range)
            let nsResult = result as NSString
            resultStr = nsResult.substring(with: NSRange(location: prefixStr.count, length: nsResult.length - prefixStr.count - 1))
        }
        return resultStr
    }
}
