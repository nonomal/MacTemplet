//
//  NNFileManager.swift
//  ESJsonFormatForMac
//
//  Created by zx on 17/6/13.
//  Copyright © 2017年 ZX. All rights reserved.
//

import AppKit
import SwiftExpand

@objcMembers
class NNFileManager: NSObject {

    private static let sharedInstance = NNFileManager()

    @objc(shared)
    class func shared() -> NNFileManager {
        return sharedInstance
    }

    @objc(createFileWithFolderPath:hFileName:mFileName:hContent:mContent:)
    func createFile(withFolderPath folderPath: String,
                    hFileName: String,
                    mFileName: String,
                    hContent: String,
                    mContent: String) {
        if !NSApplication.isSwift {
            FileManager.createFile(atPath: folderPath, name: hFileName, content: hContent, attributes: nil, isCover: true)
            FileManager.createFile(atPath: folderPath, name: mFileName, content: mContent, attributes: nil, isCover: true)
        } else {
            FileManager.createFile(atPath: folderPath, name: hFileName, content: hContent, attributes: nil, isCover: true)
        }
    }
}
