//
//  CodeGenerateController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2026/8/3.
//  Copyright © 2026 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftExpand

/// 代码生成策略
enum CodeGenerateStrategy: String, CaseIterable {
    case propertyLazy
    case batchClassCreate

    var title: String {
        switch self {
        case .propertyLazy: return "属性Lazy"
        case .batchClassCreate: return "类文件批量创建"
        }
    }

    func makeViewController() -> NSViewController {
        switch self {
        case .propertyLazy: return ProppertyLazyController()
        case .batchClassCreate: return NNBatchClassCreateController()
        }
    }
}

/// 代码生成合集页：通过 NSTabView 切换策略
@objcMembers class CodeGenerateController: NSViewController {

    private lazy var tabView: NSTabView = {
        let view = NSTabView()
        view.tabPosition = .top
        view.tabViewBorderType = .line
        view.delegate = self
        return view
    }()

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tabView)
        tabView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        CodeGenerateStrategy.allCases.forEach { strategy in
            let vc = strategy.makeViewController()
            vc.title = strategy.title
            let item = NSTabViewItem(viewController: vc)
            item.label = strategy.title
            item.identifier = strategy.rawValue as NSString
            tabView.addTabViewItem(item)
        }
    }
}

extension CodeGenerateController: NSTabViewDelegate {

    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        guard let raw = tabViewItem?.identifier as? String,
              let strategy = CodeGenerateStrategy(rawValue: raw) else { return }
        DDLog("CodeGenerate strategy: \(strategy.title)")
    }
}
