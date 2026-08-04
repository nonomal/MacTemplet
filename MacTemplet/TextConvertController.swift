//
//  TextConvertController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2026/8/3.
//  Copyright © 2026 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftExpand

/// 文本转换策略
enum TextConvertStrategy: String, CaseIterable {
    case propertyChain
    case kebabToCamel
    case underscoreToCamel
    case sassToVueProps

    var title: String {
        switch self {
        case .propertyChain: return "属性转链式"
        case .kebabToCamel: return "中线转驼峰"
        case .underscoreToCamel: return "下线转驼峰"
        case .sassToVueProps: return "sass变量转vue属性"
        }
    }

    func makeViewController() -> NSViewController {
        switch self {
        case .propertyChain: return ProppertyChainController()
        case .kebabToCamel: return KababCaseToCamelCase()
        case .underscoreToCamel: return UnderScoreToCamelCase()
        case .sassToVueProps: return SassVariableToVueProps()
        }
    }
}

/// 文本转换合集页：通过 NSTabView 切换转换策略
@objcMembers class TextConvertController: NSViewController {

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

        TextConvertStrategy.allCases.forEach { strategy in
            let vc = strategy.makeViewController()
            vc.title = strategy.title
            let item = NSTabViewItem(viewController: vc)
            item.label = strategy.title
            item.identifier = strategy.rawValue as NSString
            tabView.addTabViewItem(item)
        }
    }
}

extension TextConvertController: NSTabViewDelegate {

    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        guard let raw = tabViewItem?.identifier as? String,
              let strategy = TextConvertStrategy(rawValue: raw) else { return }
        DDLog("TextConvert strategy: \(strategy.title)")
    }
}
