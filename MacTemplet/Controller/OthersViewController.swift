//
//  OthersViewController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2020/4/1.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

import Cocoa

/// 其他例子集合
class OthersViewController: NSViewController {
    
    lazy var tabView: NSTabView = {
        let view = NSTabView.create(.zero)
        view.delegate = self
        return view
    }()
    
    lazy var list: [[String]] = {
        let list = [["NSOutlineViewController", "NSOutlineView",],
                    ["CollectionViewController", "Collection", ],
                      ["FirstViewController", "First",],
                      ["ListViewController", "ListVC",],                      
                      ["NNTableViewController", "NNTable",],
                      ["ThirdViewController", "Third",],
                      ["NNTextViewContoller", "NNTextView",],
                      ["NSPanelStudyController", "files pickAndSave",],
                      ["AppIconActionController", "AppIcon",],
                      ["NSAlertStudyController", "NSAlertStudy",],
                      ["DialogViewController", "Dialog",],
                      ["LittleActionController", "小功能",],
                      
//                      ["NSTestViewController", "测试模块",],
//                      ["TmpViewController", "Tmp模块",],
//                      ["NSPanelStudyController", "NSOpenPanelStud",],
//                      ["NSStackViewController", "StackView",],
//                      ["MapViewController", "MapView",],
//                      ["FileController", "File处理",],
                      ];
        return list
    }()
    

    // MARK: -life cycle
    override func loadView() {
        // 设置 ViewController 大小同 mainWindow
        guard let windowRect = NSApplication.shared.mainWindow?.frame else { return }
        view = NSView(frame: windowRect)
        view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setupUI()
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        tabView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10);
            make.left.equalToSuperview().offset(10);
            make.right.equalToSuperview().offset(-10);
            make.bottom.equalToSuperview().offset(-10);
        }
    }
    
    // MARK: -funtions
    func setupUI() {
        tabView.addItems(list)
        view.addSubview(tabView)
    }
}

extension OthersViewController: NSTabViewDelegate{
    
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        guard let tabViewItem = tabViewItem else { return }
        let index = tabView.tabViewItems.firstIndex(of: tabViewItem)
        print("\(#function):\(index ?? 0)")
    }
}
