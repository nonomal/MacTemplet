//
//  ProppertyChainController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/12/31.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import Cocoa
import CocoaExpand


@objcMembers class ProppertyChainController: NSViewController {
    
    lazy var textView: NNTextView = {
        let view = NNTextView.create(.zero)
        view.font = NSFont.systemFont(ofSize: 12)
        view.string = "";
        
        view.delegate = self;
        return view
    }()

    lazy var textViewOne: NNTextView = {
        let view = NNTextView.create(.zero)
        view.font = NSFont.systemFont(ofSize: 12)
        view.string = "";
        
        view.delegate = self;
        return view
    }()
    
    lazy var textField: NNTextField = {
        let view = NNTextField.create(.zero, placeholder: "var Prefix")
        view.isBordered = true
        ///是否显示边框
        view.font = NSFont.systemFont(ofSize: 13)
        view.alignment = .center
        view.isTextAlignmentVerticalCenter = true
        view.maximumNumberOfLines = 1
        view.usesSingleLineMode = true
        view.tag = 100
//        view.delegate = self

        return view
    }()
    
    lazy var textFieldOne: NNTextField = {
        let view = NNTextField.create(.zero, placeholder: "class")
        view.isBordered = true
        ///是否显示边框
        view.font = NSFont.systemFont(ofSize: 13)
        view.alignment = .center
        view.isTextAlignmentVerticalCenter = true
        view.maximumNumberOfLines = 1
        view.usesSingleLineMode = true
        view.tag = 100
//        view.delegate = self

        return view
    }()

    lazy var btn: NSButton = {
        let view: NSButton = NSButton(frame: .zero)
        view.autoresizingMask = [.width, .height]
        view.bezelStyle = .rounded
        view.title = "Done"

        view.addActionHandler { (sender) in
            NSApp.mainWindow!.makeFirstResponder(nil)
            self.createFiles()
        }
        return view
    }()
    
    lazy var btnRefresh: NSButton = {
        let view: NSButton = NSButton(frame: .zero)
        view.autoresizingMask = [.width, .height]
        view.bezelStyle = .rounded
        view.title = "刷新一下"

        view.addActionHandler { (sender) in
            NSApp.mainWindow!.makeFirstResponder(nil)
            self.convertContent()
        }
        return view
    }()
    
    
    var propertyPrefix = "nn_"
    var propertyClass = "NSObject"

    var hContent = ""
    var mContent = ""

    // MARK: -lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        view.addSubview(textView.enclosingScrollView!)
        view.addSubview(textViewOne.enclosingScrollView!)
        view.addSubview(textField)
        view.addSubview(textFieldOne)
        view.addSubview(btn)
        view.addSubview(btnRefresh)

        NoodleLineNumberView.setupLineNumber(with: textView)
        
        textField.stringValue = propertyPrefix
        textView.string =
"""
@interface UICollectionViewFlowLayout : UICollectionViewLayout

@property (nonatomic) CGSize itemSize;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic) UIEdgeInsets sectionInset;

@property (nonatomic) BOOL sectionHeadersPinToVisibleBounds;

@property (nullable, nonatomic, readonly) UICollectionView *collectionView;

@property (nullable, nonatomic, readonly) NSString *content;

@property (nonatomic, copy) NSArray<NSString *> *attributes;

@property(nonatomic, copy, readonly) UICollectionViewFlowLayout *(^items)(NSArray<NSString *> *);

@end

"""
        convertContent()
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        let items = [textView.enclosingScrollView!, textViewOne.enclosingScrollView!]
        items.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: 15, leadSpacing: 0, tailSpacing: 0)
        items.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10);
            make.bottom.equalToSuperview().offset(-45);
        }
        
        btn.snp.makeConstraints { (make) in
//            make.top.equalTo(textField).offset(5)
            make.right.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-kPadding)
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
        
        btnRefresh.snp.makeConstraints { (make) in
//            make.top.equalTo(textField).offset(5)
            make.right.equalTo(btn.snp.left).offset(-10)
            make.bottom.width.height.equalTo(btn)
        }
                
        textField.snp.remakeConstraints { (make) in
//            make.top.equalTo(textView.snp.bottom).offset(kPadding)
            make.left.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-kPadding);
            make.width.equalTo(200)
            make.height.equalTo(25)
        }
        
        textFieldOne.snp.remakeConstraints { (make) in
//            make.top.equalTo(textView.snp.bottom).offset(kPadding)
            make.left.equalTo(textField.snp.right).offset(10)
            make.bottom.width.height.equalTo(textField)
        }

    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    
    }
    // MARK: -funtions
    func convertContent() {
        propertyPrefix = textField.stringValue

        let text = textView.string
        if text.hasPrefix("@interface") {
            let list = text.components(separatedBy: " : ")
            propertyClass = list[0].replacingOccurrences(of: "@interface", with: "").trimmed
        }
        
        var hPropertys = ""
        var mPropertys = ""
        let propertys = NNPropertyModel.models(with: text)
        propertys.forEach { (model) in
            model.classType = propertyClass
            model.namePrefix = propertyPrefix
            hPropertys += model.chainContentH + "\n"
            mPropertys += model.chainContentM + "\n"
        }
        
        if let first = propertys.first {
            propertyClass = first.classType
        }
        
        hContent = fileContent(propertyClass, chainContentH: hPropertys)
        mContent = fileContent(propertyClass, chainContentM: mPropertys)
//        textViewOne.string = hContent + "\n" + mContent
        textViewOne.string =
"""
\(hContent)
\n
/----------------------------黄金分割线----------------------------/
\n
\(mContent)
"""

        textField.stringValue = propertyPrefix
        textFieldOne.stringValue = propertyClass
    }
    
    func createFiles() {
        if hContent == "" || mContent == "" {
            convertContent()
        }
        FileManager.createFile(content: hContent, name: "\(propertyClass)+Chain", type: "h")
        FileManager.createFile(content: mContent, name: "\(propertyClass)+Chain", type: "m")
    }
    
    ///创建文本内容
    func fileContent(_ classType: String, chainContentH: String) -> String {
        let copyRight = NSApplication.copyright(with: "\(classType)+Chain", type: "h")
        
        let result =
"""
\(copyRight)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface \(classType) (Chain)

\(chainContentH)

@end

NS_ASSUME_NONNULL_END

"""
        return result
    }
    
    
    ///创建文本内容
    func fileContent(_ classType: String, chainContentM: String) -> String {
        let copyRight = NSApplication.copyright(with: "\(classType)+Chain", type: "m")

        let result =
"""
\(copyRight)

#import "\(classType)+Chain.h"

@implementation \(classType) (Chain)

\(chainContentM)

@end

"""
        return result
    }
    
}


extension ProppertyChainController: NSTextViewDelegate{
    
    func textDidBeginEditing(_ notification: Notification) {
        
    }
    
    func textDidChange(_ notification: Notification) {
        convertContent()
    }
    
    func textDidEndEditing(_ notification: Notification) {
        convertContent()
    }
    
}

