//
//  DebugViewController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2026/8/3.
//  Copyright © 2026 Bin Shang. All rights reserved.
//

import Cocoa
import SwiftExpand

/// Debug 调试页：使用 NNWrapView（Flutter Wrap 对齐）排布按钮
@objcMembers class DebugViewController: NSViewController {

    struct DebugEntry {
        let title: String
        let className: String?
        let action: Selector?

        init(_ title: String, className: String? = nil, action: Selector? = nil) {
            self.title = title
            self.className = className
            self.action = action
        }
    }

    private lazy var entries: [DebugEntry] = [
        DebugEntry("WrapViewDemo", className: "WrapViewDemoController", action: #selector(openAsWindow(_:))),
        DebugEntry("NSButton Demo", className: "NSButtonDemoController", action: #selector(openAsWindow(_:))),
        DebugEntry("显示 NSToolbar Demo", action: #selector(showNSToolBarWindow(_:))),
        DebugEntry("iOS系统图标转化", className: "UImageBatchCreateContoller", action: #selector(openAsSheet(_:))),
        DebugEntry("其他转化", className: "OtherConvertController", action: #selector(openAsSheet(_:))),
        DebugEntry("Swift属性转链式", className: "ProppertyChainSwiftController", action: #selector(openAsWindow(_:))),
        DebugEntry("FlutterIconData", className: "FlutterIconDataController", action: #selector(openAsWindow(_:))),
        DebugEntry("Widget转扩展", className: "FlutterWidgetToExtController", action: #selector(openAsWindow(_:))),
        DebugEntry("文件拖拽", className: "DragFileController", action: #selector(openAsWindow(_:))),
        DebugEntry("Author", className: "AuthorInfoController", action: #selector(openAsWindow(_:))),
        DebugEntry("NSButon研究", className: "NNButtonStyleController", action: #selector(openAsWindow(_:))),
        DebugEntry("NNButton封装", className: "NNButtonStudyController", action: #selector(openAsWindow(_:))),
        DebugEntry("NNLabel封装", className: "NNLabelStudyController", action: #selector(openAsWindow(_:))),
        DebugEntry("Others", className: "OthersViewController", action: #selector(openAsWindow(_:))),
        DebugEntry("SplitView", className: "NNSplitViewController", action: #selector(openAsWindow(_:))),
        DebugEntry("YYModelSwift", className: "YYModelSwiftController", action: #selector(openAsWindow(_:))),
        DebugEntry("CollectionView模块", className: "CollectionViewController", action: #selector(openAsWindow(_:))),
        DebugEntry("测试模块", className: "NSTestViewController", action: #selector(openAsWindow(_:))),
        DebugEntry("NSAlertStudy", className: "NSAlertStudyController", action: #selector(openAsWindow(_:))),
        DebugEntry("StackView", className: "NSStackViewController", action: #selector(openAsWindow(_:))),
        DebugEntry("MapView", className: "MapViewController", action: #selector(openAsWindow(_:))),
        DebugEntry("File处理", className: "FileController", action: #selector(openAsWindow(_:))),
    ]

    private lazy var scrollView: NSScrollView = {
        let view = NSScrollView()
        view.hasVerticalScroller = true
        view.hasHorizontalScroller = true
        view.autohidesScrollers = true
        view.borderType = .noBorder
        view.drawsBackground = false
        return view
    }()

    private lazy var wrapView: NNWrapView = {
        let view = NNWrapView(frame: .zero)
        view.direction = .horizontal
        view.alignment = .start
        view.runAlignment = .start
        view.crossAxisAlignment = .center
        view.spacing = 10
        view.runSpacing = 10
        view.textDirection = .ltr
        view.verticalDirection = .down
        return view
    }()

    private var itemList: [NSButton] = []
    private var openedWindowCtrls: [NSWindowController] = []
    private var isUpdatingWrapFrame = false

    private lazy var toolbarWindowCtrl: NSWindowController = {
        let controller = DepartmentViewController()
        let screenSize = NSScreen.main?.frame ?? .zero
        let contentRect = NSRect(x: 0, y: 0,
                                 width: max(screenSize.width * 0.5, 640),
                                 height: max(screenSize.height * 0.5, 420))
        let window = NSWindow(contentRect: contentRect,
                              styleMask: [.titled, .resizable, .miniaturizable, .closable, .fullSizeContentView],
                              backing: .buffered,
                              defer: false)
        window.minSize = NSSize(width: 640, height: 420)
        window.center()
        window.title = "Swift-NSToolBar"
        window.contentViewController = controller
        window.isReleasedWhenClosed = false
        return NNTabViewController(window: window)
    }()

    // MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true

        itemList = entries.enumerated().map { offset, entry in
            let button = NSButton(title: entry.title, target: self, action: entry.action)
            button.tag = offset
            let cell = NNButtonCell(textCell: entry.title)
            cell.cornerRadius = 6
            button.cell = cell
            button.bezelStyle = .smallSquare
            button.title = entry.title
            button.target = self
            button.action = entry.action
            button.sizeToFit()
//            button.wantsLayer = true
//            button.layer?.borderWidth = 1
//            button.layer?.borderColor = NSColor.systemBlue.cgColor
//            button.layer?.cornerRadius = 4
            return button
        }
        wrapView.replaceArrangedSubviews(itemList)

        scrollView.documentView = wrapView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
        ])
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        updateWrapDocumentFrameIfNeeded()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func updateWrapDocumentFrameIfNeeded() {
        guard !isUpdatingWrapFrame else { return }
        isUpdatingWrapFrame = true
        defer { isUpdatingWrapFrame = false }

        let width = max(scrollView.contentSize.width, scrollView.bounds.width, 1)
        let probe = NSRect(x: 0, y: 0, width: width, height: max(wrapView.bounds.height, 1))
        if abs(wrapView.frame.width - probe.width) > 0.5 {
            wrapView.frame = probe
        }
        wrapView.needsLayout = true
        wrapView.layoutSubtreeIfNeeded()

        let fitted = wrapView.fittedContentSize
        let newFrame = NSRect(x: 0, y: 0,
                              width: max(width, fitted.width),
                              height: max(fitted.height, 1))
        if abs(wrapView.frame.width - newFrame.width) > 0.5
            || abs(wrapView.frame.height - newFrame.height) > 0.5 {
            wrapView.frame = newFrame
        }
    }

    // MARK: - actions（须对 ObjC 运行时可见，不能 private）

    @objc func showNSToolBarWindow(_ sender: Any?) {
        toolbarWindowCtrl.showWindow(self)
        toolbarWindowCtrl.window?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func openAsSheet(_ sender: NSButton) {
        guard let entry = entry(for: sender), let className = entry.className else { return }
        guard NNClassFromString(className) != nil else {
            DDLog("Debug 入口类不存在: \(className)")
            return
        }

        let vc = NSCtrFromString(className)
        vc.title = entry.title
        vc.preferredContentSize = CGSize(width: kScreenWidth * 0.4, height: kScreenHeight * 0.4)
        vc.showSheet()
    }

    @objc func openAsWindow(_ sender: NSButton) {
        guard let entry = entry(for: sender), let className = entry.className else { return }
        guard NNClassFromString(className) != nil else {
            DDLog("Debug 入口类不存在: \(className)")
            return
        }

        let vc = NSCtrFromString(className)
        vc.title = entry.title

        let size = CGSize(width: max(NSScreen.sizeWidth * 0.5, 720),
                          height: max(NSScreen.sizeHeight * 0.55, 480))
        let window = NSWindow(vc: vc, size: size)
        window.title = entry.title
        window.isReleasedWhenClosed = false
        window.center()

        let ctrl = NSWindowController(window: window)
        openedWindowCtrls.append(ctrl)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(debugWindowWillClose(_:)),
                                               name: NSWindow.willCloseNotification,
                                               object: window)

        ctrl.showWindow(self)
        window.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func entry(for sender: NSButton) -> DebugEntry? {
        guard entries.indices.contains(sender.tag) else { return nil }
        return entries[sender.tag]
    }

    @objc func debugWindowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: window)
        openedWindowCtrls.removeAll { $0.window === window }
    }
}
