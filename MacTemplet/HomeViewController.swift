//
//  HomeViewController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/27.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftExpand

private let kDefaultTabIndex = "kDefaultTabIndex_v2"

@objcMembers
class HomeViewController: NSViewController {

    lazy var tabView: NSTabView = {
        let view = NSTabView()
        view.delegate = self
        return view
    }()

    /// Bypass NSViewController+Hook swizzled loadView (keeps content sized correctly).
    override func loadView() {
        view = NNView(frame: NSRect(x: 0, y: 0, width: 900, height: 600))
        view.wantsLayer = true
        view.autoresizingMask = [.width, .height]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        tabView.snp.remakeConstraints { make in
            make.top.equalTo(view).offset(kY_GAP)
            make.left.equalTo(view).offset(kX_GAP)
            make.right.equalTo(view).offset(-kX_GAP)
            make.bottom.equalTo(view).offset(-kY_GAP)
        }
    }

    private func setupUI() {
        var list: [[String]] = [
            ["JsonToModelController", "JSON转模型"],
            ["CodeGenerateController", "代码生成"],
            ["TextConvertController", "文本转换"],
            ["UImageBatchCreateContoller", " 字符串转 UImage"],
            ["UImageBatchCreateByAssetContoller", "UImage转化"],
            ["FlutterPluginConvertController", "Flutter Plugin"],
            ["DragImagesToBase64Controller", "图片转base64"],
        ]
        #if DEBUG
        list.append(["DebugViewController", "Debug"])
        #endif
        tabView.addItems(list)

        if let obj = UserDefaults.standard.object(forKey: kDefaultTabIndex) as? NSNumber {
            var idx = obj.intValue
            idx = idx < list.count ? idx : 0
            tabView.selectTabViewItem(at: idx)
        }
        view.addSubview(tabView)
    }
}

extension HomeViewController: NSTabViewDelegate {
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        guard let tabViewItem = tabViewItem,
              let index = tabView.tabViewItems.firstIndex(of: tabViewItem) else { return }
        UserDefaults.standard.set(index, forKey: kDefaultTabIndex)
        UserDefaults.standard.synchronize()
    }
}
