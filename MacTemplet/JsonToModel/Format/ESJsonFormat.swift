//
//  ESJsonFormat.swift
//  ESJsonFormat
//
//  Created by 尹桥印 on 15/6/28.  Change by ZX on 17/5/17
//  Copyright (c) 2015年 EnjoySR. All rights reserved.
//

import AppKit
import SwiftExpand

private var esJsonFormatSharedPlugin: ESJsonFormat?
private var esJsonFormatInstance: ESJsonFormat?

@objcMembers
class ESJsonFormat: NSObject {

    var isSwift = false
    private(set) var bundle: Bundle!

    private var eventMonitor: Any?
    private var currentFilePath: String?
    private var currentProjectPath: String?
    private var currentTextView: NSTextView?
    private var notiTag = false

    @objc(sharedPlugin)
    class func sharedPlugin() -> ESJsonFormat? {
        return esJsonFormatSharedPlugin
    }

    @objc(instance)
    class func instance() -> ESJsonFormat? {
        return esJsonFormatInstance
    }

    @objc(initWithBundle:)
    init(bundle plugin: Bundle) {
        super.init()
        bundle = plugin
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didApplicationFinishLaunchingNotification(_:)),
            name: NSApplication.didFinishLaunchingNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationLog(_:)),
            name: NSTextView.didChangeSelectionNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationLog(_:)),
            name: NSNotification.Name("IDEEditorDocumentDidChangeNotification"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationLog(_:)),
            name: NSNotification.Name("PBXProjectDidOpenNotification"),
            object: nil
        )
        esJsonFormatInstance = self
    }

    @objc(notificationLog:)
    func notificationLog(_ notify: Notification) {
        if !notiTag { return }

        if notify.name == NSTextView.didChangeSelectionNotification {
            if let text = notify.object as? NSTextView {
                currentTextView = text
            }
        } else if notify.name.rawValue == "IDEEditorDocumentDidChangeNotification" {
            let array = notify.userInfo?["IDEEditorDocumentChangeLocationsKey"] as? NSObject
            let urls = array?.value(forKey: "documentURL") as? [Any]
            if let url = urls?.first as? URL {
                currentFilePath = url.absoluteString
            }
        } else if notify.name.rawValue == "PBXProjectDidOpenNotification" {
            if let path = (notify.object as? NSObject)?.value(forKey: "path") as? String {
                currentProjectPath = path
                ESPbxprojInfo.share().setParams(withPath: (path as NSString).appendingPathComponent("project.pbxproj"))
            }
        }
    }

    @objc(outputResult:)
    func outputResult(_ noti: Notification) {
        guard let classInfo = noti.object as? ESClassInfo else { return }

        if ESJsonFormatSetting.defaultSetting().outputToFiles {
            let panel = NSOpenPanel()
            panel.title = "ESJsonFormat"
            panel.canChooseDirectories = true
            panel.canChooseFiles = false

            if panel.runModal() == .OK {
                let folderPath = panel.urls.first?.relativePath ?? ""
                classInfo.createFile(withFolderPath: folderPath)
                NSWorkspace.shared.openFile(folderPath)
            }
        } else {
            guard let currentTextView = currentTextView else { return }

            if !NSApplication.isSwift {
                currentTextView.insertText(classInfo.propertyContent)
                currentTextView.insertText(
                    classInfo.classInsertTextViewContentForH,
                    replacementRange: NSRange(location: currentTextView.string.count, length: 0)
                )

                let atClassContent = classInfo.atClassContent
                if !atClassContent.isEmpty {
                    let atInsertRange = (currentTextView.string as NSString).range(of: "\n@interface")
                    if atInsertRange.location != NSNotFound {
                        currentTextView.insertText(
                            "\n\(atClassContent)",
                            replacementRange: NSRange(location: atInsertRange.location, length: 0)
                        )
                    }
                }

                if let currentFilePath = currentFilePath {
                    let urlStr = String(format: "%@m", (currentFilePath as NSString).substring(with: NSRange(location: 0, length: currentFilePath.count - 1)))
                    if let writeUrl = URL(string: urlStr) {
                        var originalContent = (try? String(contentsOf: writeUrl, encoding: .utf8)) ?? ""

                        if ESJsonFormatSetting.defaultSetting().impOjbClassInArray {
                            let methodStr = ESJsonFormatManager.methodContentOfObjectClassInArray(withClassInfo: classInfo)
                            if !methodStr.isEmpty {
                                let lastEndRange = (originalContent as NSString).range(of: "@end")
                                if lastEndRange.location != NSNotFound {
                                    originalContent = (originalContent as NSString).replacingCharacters(in: NSRange(location: lastEndRange.location, length: 0), with: methodStr)
                                }
                            }
                        }
                        originalContent = (originalContent as NSString).replacingCharacters(
                            in: NSRange(location: originalContent.count, length: 0),
                            with: classInfo.classInsertTextViewContentForM
                        )
                        try? originalContent.write(to: writeUrl, atomically: true, encoding: .utf8)
                    }
                }
            } else {
                currentTextView.insertText(classInfo.propertyContent)
                currentTextView.insertText(
                    classInfo.classInsertTextViewContentForH,
                    replacementRange: NSRange(location: currentTextView.string.count, length: 0)
                )
            }
        }
    }

    @objc(didApplicationFinishLaunchingNotification:)
    func didApplicationFinishLaunchingNotification(_ noti: Notification) {
        notiTag = true
        NotificationCenter.default.removeObserver(self, name: NSApplication.didFinishLaunchingNotification, object: nil)

        guard let menuItem = NSApp.mainMenu?.item(withTitle: "Window") else { return }

        let menu = NSMenu()

        let inputJsonWindow = NSMenuItem(title: "Input JSON window", action: #selector(showInputJsonWindow(_:)), keyEquivalent: "J")
        inputJsonWindow.keyEquivalentModifierMask = [.capsLock, .control]
        inputJsonWindow.target = self
        menu.addItem(inputJsonWindow)

        let settingWindow = NSMenuItem(title: "Setting", action: #selector(showSettingWindow(_:)), keyEquivalent: "")
        settingWindow.target = self
        menu.addItem(settingWindow)

        let item = NSMenuItem(title: "ESJsonFormat", action: nil, keyEquivalent: "")
        item.submenu = menu
        menuItem.submenu?.addItem(item)
    }

    @objc(showInputJsonWindow:)
    func showInputJsonWindow(_ item: NSMenuItem) {
        if currentTextView == nil || currentFilePath == nil {
            let error = NSError(domain: "Current state is not edit!", code: 0, userInfo: nil)
            let alert = NSAlert(error: error)
            alert.runModal()
            return
        }
        notiTag = false
    }

    @objc(showSettingWindow:)
    func showSettingWindow(_ item: NSMenuItem) {
    }

    @objc(windowWillClose)
    func windowWillClose() {
        notiTag = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
