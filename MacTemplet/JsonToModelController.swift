//
//  JsonToModelController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/8/14.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftExpand

@objcMembers
class JsonToModelController: NSViewController {

    lazy var textView: NNTextView = {
        let view = NNTextView.create(.zero)
        view.font = NSFont.systemFont(ofSize: 12)
        view.delegate = self
        view.string = "NSScrollView上无法滚动的NSTextView"
        return view
    }()

    lazy var tableView: NNTableView = {
        let view = NNTableView.create(.zero)
        view.headerView = nil
        view.selectionHighlightStyle = .none
        view.addTableColumn(titles: ["colume0"])
        view.dataSource = self
        view.delegate = self
        view.enclosingScrollView?.hasHorizontalScroller = false
        view.enclosingScrollView?.hasVerticalScroller = false
        view.enclosingScrollView?.autohidesScrollers = true
        return view
    }()

    lazy var bottomView: NNView = {
        let view = NNView()
        view.autoresizingMask = [.width, .height]
        view.addSubview(textField)
        view.addSubview(textFieldTwo)
        view.addSubview(textFieldThree)
        view.addSubview(textLabel)
        view.addSubview(btn)
        view.addSubview(popBtn)
        view.addSubview(valueTypeLab)
        return view
    }()

    lazy var textField: NNTextField = {
        let view = NNTextField.create(.zero, placeholder: "Class Prefix")
        view.isBordered = true
        view.font = NSFont.systemFont(ofSize: 13)
        view.alignment = .center
        view.isTextAlignmentVerticalCenter = true
        view.maximumNumberOfLines = 1
        view.usesSingleLineMode = true
        view.tag = 100
        view.delegate = self
        return view
    }()

    lazy var textFieldTwo: NNTextField = {
        let view = NNTextField.create(.zero, placeholder: "Root Class name")
        view.isBordered = true
        view.font = NSFont.systemFont(ofSize: 13)
        view.alignment = .center
        view.isTextAlignmentVerticalCenter = true
        view.maximumNumberOfLines = 1
        view.usesSingleLineMode = true
        view.tag = 101
        view.delegate = self
        return view
    }()

    lazy var textFieldThree: NNTextField = {
        let view = NNTextField.create(.zero, placeholder: "Supper Class name")
        view.isBordered = true
        view.font = NSFont.systemFont(ofSize: 13)
        view.alignment = .center
        view.isTextAlignmentVerticalCenter = true
        view.maximumNumberOfLines = 1
        view.usesSingleLineMode = true
        view.tag = 102
        view.delegate = self
        return view
    }()

    lazy var textLabel: HHLabel = {
        let view = HHLabel(frame: .zero)
        view.font = NSFont.systemFont(ofSize: 13)
        view.alignment = .center
        view.maximumNumberOfLines = 1
        view.usesSingleLineMode = true
        return view
    }()

    lazy var valueTypeLab: HHLabel = {
        let view = HHLabel(frame: .zero)
        view.font = NSFont.systemFont(ofSize: 13)
        view.textColor = NSColor.gray
        view.alignment = .center
        view.maximumNumberOfLines = 1
        view.usesSingleLineMode = true
        view.stringValue = types.first ?? ""
        view.mouseDownBlock = { [weak self] sender in
            guard let self else { return }
            sender.isSelectable = !sender.isSelectable
            sender.stringValue = sender.isSelectable ? (self.types.last ?? "") : (self.types.first ?? "")
            sender.textColor = sender.isSelectable ? NSColor.red : NSColor.gray
            self.hanldeJson()
        }
        return view
    }()

    lazy var types: [String] = {
        return ["默认类型", "字符串类型"]
    }()

    lazy var popBtn: NSPopUpButton = {
        let view = NSPopUpButton(frame: .zero, pullsDown: false)
        view.autoenablesItems = true
        let list = ["北京", "上海", "广州", "深圳"]
        view.addItems(withTitles: list)
        view.addActionHandler { [weak self] _ in
            NSApp.keyWindow?.makeFirstResponder(nil)
            self?.hanldeJson()
        }
        return view
    }()

    lazy var btn: NSButton = {
        let view = NSButton(frame: .zero)
        view.autoresizingMask = [.width, .height]
        view.bezelStyle = .rounded
        view.title = "保存"
        view.addActionHandler { [weak self] _ in
            NSApp.keyWindow?.makeFirstResponder(nil)
            self?.creatFile()
        }
        return view
    }()

    lazy var langsDic: [String: NNLanguageModel] = {
        var mdic = [String: NNLanguageModel]()
        let list = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: nil) ?? []
        for url in list {
            guard let data = try? Data(contentsOf: url) else { continue }
            do {
                let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable: Any]
                if let dic, let langModel = NNLanguageModel.yy_model(withJSON: dic) {
                    mdic[langModel.displayLangName ?? ""] = langModel
                }
            } catch {
                NSAlert(error: error).runModal()
            }
        }
        return mdic
    }()

    lazy var dataList: NSMutableArray = {
        return NSMutableArray()
    }()

    var hFilename: String?
    var mFilename: String?
    var langModel: NNLanguageModel?

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.set("NN", forKey: kClassPrefix)
        UserDefaults.standard.set("RootModel", forKey: kRootClass)
        UserDefaults.standard.set("NSObject", forKey: kSuperClass)
        UserDefaults.standard.synchronize()

        textField.stringValue = UserDefaults.standard.string(forKey: kClassPrefix) ?? ""
        textFieldTwo.stringValue = UserDefaults.standard.string(forKey: kRootClass) ?? ""
        textFieldThree.stringValue = UserDefaults.standard.string(forKey: kSuperClass) ?? ""

        view.addSubview(textView.enclosingScrollView!)
        view.addSubview(tableView.enclosingScrollView!)
        view.addSubview(bottomView)
        NoodleLineNumberView.setupLineNumber(with: textView)

        for _ in 0..<2 {
            let classModel = NNClassInfoModel()
            dataList.add(classModel)
        }

        updateLanguages()
        readFile()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotifation(_:)),
            name: NSWindow.didBecomeKeyNotification,
            object: nil
        )
    }

    @objc func handleNotifation(_ n: Notification) {
        tableView.reloadData()
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        textView.enclosingScrollView!.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().offset(-45)
        }

        tableView.enclosingScrollView!.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(textView.enclosingScrollView!.snp.right).offset(15)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-45)
        }

        bottomView.snp.makeConstraints { make in
            make.top.equalTo(textView.enclosingScrollView!.snp.bottom).offset(kPadding)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(textField.superview!).offset(kPadding)
            make.left.equalTo(bottomView.superview!).offset(kX_GAP)
            make.width.equalTo(100)
            make.bottom.equalTo(bottomView.superview!).offset(-kPadding)
        }

        textFieldTwo.snp.makeConstraints { make in
            make.top.equalTo(textField.superview!).offset(kPadding)
            make.left.equalTo(textField.snp.right).offset(kX_GAP)
            make.width.equalTo(100)
            make.bottom.equalTo(bottomView.superview!).offset(-kPadding)
        }

        textFieldThree.snp.makeConstraints { make in
            make.top.equalTo(textField.superview!).offset(kPadding)
            make.left.equalTo(textFieldTwo.snp.right).offset(kX_GAP)
            make.width.equalTo(100)
            make.bottom.equalTo(bottomView.superview!).offset(-kPadding)
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.superview!).offset(kPadding)
            make.left.equalTo(textFieldThree.snp.right).offset(kX_GAP)
            make.width.equalTo(150)
            make.bottom.equalTo(bottomView.superview!).offset(-kPadding)
        }

        btn.snp.makeConstraints { make in
            make.top.equalTo(textField.superview!).offset(kPadding)
            make.right.equalTo(bottomView.superview!).offset(-kX_GAP)
            make.width.equalTo(80)
            make.bottom.equalTo(bottomView.superview!).offset(-kPadding)
        }

        popBtn.snp.makeConstraints { make in
            make.top.equalTo(textField.superview!).offset(kPadding)
            make.right.equalTo(btn.snp.left).offset(-kX_GAP)
            make.width.equalTo(160)
            make.bottom.equalTo(bottomView.superview!).offset(-kPadding)
        }

        valueTypeLab.snp.makeConstraints { make in
            make.top.equalTo(textField.superview!).offset(kPadding)
            make.right.equalTo(popBtn.snp.left).offset(-kX_GAP)
            make.width.equalTo(80)
            make.bottom.equalTo(bottomView.superview!).offset(-kPadding)
        }
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        let titleOfSelectedItem = UserDefaults.standard.string(forKey: kDisplayName)
        if let titleOfSelectedItem {
            popBtn.selectItem(withTitle: titleOfSelectedItem)
        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        let folderPath = "/Users/shang/Downloads"
        UserDefaults.standard.set(folderPath, forKey: kFolderPath)
    }

    // MARK: - functions

    func readFile() {
        guard let path = Bundle.main.path(forResource: "appinfo", ofType: "txt") else { return }
        let content = try? String(contentsOfFile: path, encoding: .utf8)
        textView.string = content ?? ""
        hanldeJson()
    }

    func clearFileOutputPath() {
        UserDefaults.standard.removeObject(forKey: kFolderPath)
        UserDefaults.standard.synchronize()
        let alert = NSAlert()
        alert.messageText = "\nClear Success."
        alert.runModal()
    }

    func hanldeJson() {
        if textField.stringValue.isEmpty
            || textFieldTwo.stringValue.isEmpty
            || textFieldThree.stringValue.isEmpty {
            NSAlert(
                title: "提示",
                message: "前缀,类名,父类均不能为空",
                btnTitles: [kTitleKnow],
                style: .informational
            ).runModal()
            return
        }

        setupDefault(with: popBtn)

        let result = textView.string.objValue
        textLabel.stringValue = result != nil ? "Valid JSON Structure" : "JSON isn't valid"
        textLabel.textColor = result != nil ? NSColor.systemGreen : NSColor.red

        guard let result else {
            let alert = NSAlert(
                title: "警告",
                message: "Error：Json is invalid",
                btnTitles: [kTitleKnow],
                style: .informational
            )
            if let window = NSApp.keyWindow {
                alert.beginSheetModal(for: window) { returnCode in
                    DDLog("\(returnCode)")
                }
            }
            return
        }

        let classInfo = ESClassInfo.deal(withJson: result) { [weak self] hFilename, mFilename in
            self?.hFilename = hFilename
            self?.mFilename = mFilename
        }
        classInfo?.langModel = langModel
        if let classInfo {
            outputResult(classInfo)
        }
    }

    func outputResult(_ classInfo: ESClassInfo) {
        if ESJsonFormatSetting.defaultSetting().outputToFiles {
            let panel = NSOpenPanel.create(fileTypes: nil, allowsMultipleSelection: false)
            if panel.runModal() == .OK, let url = panel.urls.first {
                let folderPath = url.path
                classInfo.createFile(withFolderPath: folderPath)
                NSWorkspace.shared.openFile(folderPath)
            }
        } else {
            if !NSApplication.isSwift {
                if let classModel = dataList.firstObject as? NNClassInfoModel {
                    classModel.modelName = classInfo.modelName
                    classModel.hContent = classInfo.classDesc(withFirstFile: true)
                    classModel.hContent = classModel.hContent?.replacingOccurrences(
                        of: "#import <Foundation/Foundation.h>",
                        with: langModel?.staticImports ?? ""
                    )
                    if valueTypeLab.isSelectable {
                        classModel.hContent = classModel.hContent?
                            .replacingOccurrences(of: "assign) NSInteger ", with: "copy) NSString *")
                            .replacingOccurrences(of: "assign) long long ", with: "copy) NSString *")
                            .replacingOccurrences(of: "assign) CGFloat ", with: "copy) NSString *")
                    }
                }
                if let classModelOne = dataList.lastObject as? NNClassInfoModel {
                    classModelOne.modelName = classInfo.modelName
                    classModelOne.mContent = classInfo.classDesc(withFirstFile: false)
                }
            } else {
                if let classModel = dataList.firstObject as? NNClassInfoModel {
                    classModel.modelName = classInfo.modelName
                    classModel.hContent = classInfo.classDesc(withFirstFile: true)
                    classModel.hContent = classModel.hContent?.replacingOccurrences(
                        of: "import Foundation",
                        with: langModel?.staticImports ?? ""
                    )
                    if let hContent = classModel.hContent,
                       !hContent.contains("NSObject {"),
                       let parent = langModel?.defaultParentWithUtilityMethods {
                        let tmp = "NSObject, \(parent) {"
                        classModel.hContent = hContent.replacingOccurrences(of: "NSObject {", with: tmp)
                    }
                    if valueTypeLab.isSelectable {
                        classModel.hContent = classModel.hContent?
                            .replacingOccurrences(of: ": Int = 0", with: ": String = \"0\"")
                            .replacingOccurrences(of: ": Double = 0", with: ": String = \"0\"")
                    }
                }
            }
            tableView.reloadData()
        }
    }

    func creatFile() {
        guard let classModelH = dataList.firstObject as? NNClassInfoModel,
              let classModelM = dataList.lastObject as? NNClassInfoModel,
              let hContent = classModelH.hContent,
              let mContent = classModelM.mContent else { return }

        if let folderPath = UserDefaults.standard.value(forKey: kFolderPath) as? String {
            NNFileManager.shared().createFile(
                withFolderPath: folderPath,
                hFileName: hFilename ?? "",
                mFileName: mFilename ?? "",
                hContent: hContent,
                mContent: mContent
            )
            NSWorkspace.shared.openFile(folderPath)
        } else {
            let panel = NSOpenPanel.create(fileTypes: nil, allowsMultipleSelection: false)
            if panel.runModal() == .OK, let url = panel.urls.first {
                let folderPath = url.path
                UserDefaults.standard.setValue(folderPath, forKey: kFolderPath)
                DDLog("\(folderPath)")
                NNFileManager.shared().createFile(
                    withFolderPath: folderPath,
                    hFileName: hFilename ?? "",
                    mFileName: mFilename ?? "",
                    hContent: hContent,
                    mContent: mContent
                )
                NSWorkspace.shared.openFile(folderPath)
            }
        }
    }

    func updateLanguages() {
        let items = langsDic.keys.sorted()
        popBtn.removeAllItems()
        popBtn.addItems(withTitles: items)
    }

    func setupDefault(with sender: NSPopUpButton) {
        guard let titleOfSelectedItem = sender.titleOfSelectedItem else { return }
        langModel = langsDic[titleOfSelectedItem]
        UserDefaults.standard.set(titleOfSelectedItem, forKey: kDisplayName)
        let isSwift = titleOfSelectedItem.contains("Swift") || titleOfSelectedItem.contains("swift")
        UserDefaults.standard.set(isSwift, forKey: kIsSwift)
        UserDefaults.archiveObject(langModel, forkey: "langModel")
        UserDefaults.standard.synchronize()
    }
}

// MARK: - NSTableViewDataSource, NSTableViewDelegate

extension JsonToModelController: NSTableViewDataSource, NSTableViewDelegate, NSTextViewDelegate, NSTextFieldDelegate {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return NSApplication.isSwift ? 1 : 2
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let tableViewH = tableView.frame.height
        let height = NSApplication.isSwift ? tableViewH : tableViewH * 0.5
        return height > 0 ? height : tableView.rowHeight
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = NSTableCellViewTen.makeView(tableView: tableView, owner: self)
        cell.checkBox.isHidden = true

        if dataList.count == 0 {
            return cell
        }

        guard let classModel = dataList[row] as? NNClassInfoModel else {
            return cell
        }

        if !NSApplication.isSwift {
            cell.textLabel.stringValue = (classModel.modelName ?? "") + (row == 0 ? ".h" : ".m")
            cell.textView.string = row == 0 ? (classModel.hContent ?? "") : (classModel.mContent ?? "")
        } else {
            cell.textLabel.stringValue = (classModel.modelName ?? "") + ".swift"
            cell.textView.string = classModel.hContent ?? ""
        }

        cell.textLabel.backgroundColor = NSColor.background
        return cell
    }

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if let rowView = tableView.rowView(atRow: row, makeIfNecessary: false) {
            rowView.selectionHighlightStyle = .regular
            rowView.isEmphasized = false
        }
        DDLog("shouldSelectRow : \(row)")
        return true
    }

    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        DDLog("\(tableColumn)")
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
    }

    func tableView(
        _ tableView: NSTableView,
        toolTipFor cell: NSCell,
        rect: NSRectPointer,
        tableColumn: NSTableColumn?,
        row: Int,
        mouseLocation: NSPoint
    ) -> String {
        guard let tableColumn else { return "" }
        let item = tableView.tableColumns.firstIndex(of: tableColumn) ?? 0
        return "{\(row),\(item)}"
    }

    func tableView(_ tableView: NSTableView, shouldShowCellExpansionFor tableColumn: NSTableColumn?, row: Int) -> Bool {
        return true
    }

    func tableView(_ tableView: NSTableView, shouldTrackCell cell: NSCell, for tableColumn: NSTableColumn?, row: Int) -> Bool {
        return true
    }
}

// MARK: - NSTextDelegate

extension JsonToModelController: NSTextDelegate {

    func textDidBeginEditing(_ notification: Notification) {
    }

    func textDidChange(_ notification: Notification) {
        guard let view = notification.object as? NSTextView else { return }
        DDLog("length:\(view.string.count)")
        if let containerSize = view.textContainer?.containerSize {
            DDLog("containerSize:\(containerSize)")
        }
        view.scrollRangeToVisible(NSRange(location: Int.max, length: 0))
        if !view.string.isEmpty {
            hanldeJson()
        }
    }

    func textDidEndEditing(_ notification: Notification) {
    }
}

// MARK: - NSControlTextEditingDelegate

extension JsonToModelController: NSControlTextEditingDelegate {

    func controlTextDidBeginEditing(_ obj: Notification) {
    }

    func controlTextDidChange(_ obj: Notification) {
    }

    func controlTextDidEndEditing(_ obj: Notification) {
        UserDefaults.standard.set(textField.stringValue, forKey: kClassPrefix)
        UserDefaults.standard.set(textFieldTwo.stringValue, forKey: kRootClass)
        UserDefaults.standard.set(textFieldThree.stringValue, forKey: kSuperClass)
        UserDefaults.standard.synchronize()
        hanldeJson()
    }
}
