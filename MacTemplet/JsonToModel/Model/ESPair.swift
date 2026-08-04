//
//  ESPair.swift
//  ESJsonFormat
//

import Foundation

@objcMembers
class ESPair: NSObject {
    var first: Any?
    var second: Any?

    @objc(createWithFirst:second:)
    class func create(withFirst first: Any?, second: Any?) -> ESPair {
        let pair = ESPair()
        pair.first = first
        pair.second = second
        return pair
    }
}
