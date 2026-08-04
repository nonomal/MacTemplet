//
//  NNRootModel.swift
//  MacTemplet
//
//  Created by shang on 2020/01/11 21:44
//  Copyright © 2020 shang. All rights reserved.
//

import Foundation

@objcMembers
class NNRootModel: NSObject {

    var object: NNObjectModel?
    var status: String?
}

@objcMembers
class NNObjectModel: NSObject {

    var blocks: [NNBlocksModel]?
    var buildings: [NNBuildingsModel]?
    var floors: [NNFloorsModel]?

    static func modelContainerPropertyGenericClass() -> [String: Any]? {
        return [
            "blocks": NNBlocksModel.classForCoder(),
            "buildings": NNBuildingsModel.classForCoder(),
            "floors": NNFloorsModel.classForCoder()
        ]
    }
}

@objcMembers
class NNBlocksModel: NSObject {

    var desc: String?
    var disabled: Bool = false
    var ID: Int = 0
    var level: Int = 0
    var name: String?
    var value: Int = 0

    static func modelCustomPropertyMapper() -> [String: Any]? {
        return ["ID": "id", "desc": "description"]
    }
}

@objcMembers
class NNBuildingsModel: NSObject {

    var disabled: Bool = false
    var ID: Int = 0
    var level: Int = 0
    var name: String?
    var value: Int = 0

    static func modelCustomPropertyMapper() -> [String: Any]? {
        return ["ID": "id"]
    }
}

@objcMembers
class NNFloorsModel: NSObject {

    var disabled: Bool = false
    var ID: Int = 0
    var level: Int = 0
    var name: String?
    var value: Int = 0

    static func modelCustomPropertyMapper() -> [String: Any]? {
        return ["ID": "id"]
    }
}
