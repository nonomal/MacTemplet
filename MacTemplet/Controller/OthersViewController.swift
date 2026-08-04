//
//  OthersViewController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/4/1.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import Cocoa
import Speech

/// 其他例子集合
@objcMembers class OthersViewController: NSViewController {
    
    lazy var tabView: NSTabView = {
        let view = NSTabView()
        view.tabPosition = .top
        view.tabViewBorderType = .line
        view.delegate = self
        return view
    }()
    
    lazy var list: [(NSViewController, String)] = {
        return [(NSOutlineViewController(), "NSOutlineView"),
                (CollectionViewController(), "Collection"),
                  (NNTextViewContoller(), "NNTextView"),
                  (NSPanelStudyController(), "Files pickAndSave"),
                  (AppIconActionController(), "AppIcon"),
                  (NSAlertStudyController(), "NSAlertStudy"),
                  (LittleActionController(), "小功能"),
                  (ShowViewController(), "控制器呈现"),
                  (BookListController(), "折叠分段列表"),
                  (PageControllerDemo(), "PageControllerDemo"),
                      ]
    }()
    

    // MARK: -life cycle
    override func loadView() {
        let fallback = NSRect(x: 0, y: 0,
                              width: max(NSScreen.main?.frame.width ?? 800, 1) * 0.5,
                              height: max(NSScreen.main?.frame.height ?? 600, 1) * 0.5)
        let windowRect = viewWindowFrame() ?? fallback
        view = NSView(frame: windowRect)
        view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setupUI()
        tabView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
//        let synthetizer = NSSpeechSynthesizer(voice: nil)
//        synthetizer?.startSpeaking("Welcome to app'codeHelper")
    }
    
    // MARK: -funtions
    func setupUI() {
        tabView.addItems(list)
        view.addSubview(tabView)
    }

    private func viewWindowFrame() -> NSRect? {
        if let frame = view.window?.frame { return frame }
        if let frame = NSApp.keyWindow?.frame { return frame }
        return NSApplication.shared.mainWindow?.frame
    }
}

extension OthersViewController: NSTabViewDelegate{
    
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        guard let tabViewItem = tabViewItem else { return }
        let index = tabView.tabViewItems.firstIndex(of: tabViewItem)
        print("\(#function):\(index ?? 0)")
    }
}
