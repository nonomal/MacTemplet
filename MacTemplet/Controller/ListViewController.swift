//
//  ListViewController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/8.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftExpand

@objcMembers class ListViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        tableView.enclosingScrollView?.snp.makeConstraints { make in
            make.edges.equalTo(tableView.enclosingScrollView!.superview!)
        }
    }

    override func viewWillAppear() {
        super.viewWillAppear()
    }

    func setupTableView() {
        var columns = ["columeOne", "columeTwo", "columeThree"]
        if let firstRow = list.first {
            columns = firstRow.map { "\($0)" }
        }
        columns.forEach { obj in
            let column = NSTableColumn.create(identifier: obj, title: obj)
            tableView.addTableColumn(column)
        }
        if let scrollView = tableView.enclosingScrollView {
            view.addSubview(scrollView)
        }
    }

    // MARK: - lazy

    lazy var tableView: NNTableView = {
        let view = NNTableView.create(.zero)
        view.delegate = self
        view.dataSource = self
        return view
    }()

    lazy var list: [[Any]] = {
        return [
            ["名称", "总数", "剩余", "IP", "状态", "状态1", "状态2", "状态3", "状态4"],
            ["ces1", 0, 0, "3.4.5.6", "027641081087", "1", 0, "3.4.5.6", "027641081087"],
            ["ces2", 0, 0, "3.4.5.6", "027641081087", "2", 0, "3.4.5.6", "027641081087"],
            ["ces3", 0, 0, "3.4.5.6", "027641081087", "3", 0, "3.4.5.6", "027641081087"],
            ["ces4", 0, 0, "3.4.5.6", "027641081087", "4", 0, "3.4.5.6", "027641081087"],
            ["ces5", 0, 0, "3.4.5.6", "027641081087", "5", 0, "3.4.5.6", "027641081087"],
            ["ces6", "", 0, "3.4.5.6", "027641081087", "6", 0, "3.4.5.6", "027641081087"],
            ["ces7", 0, 0, "3.4.5.6", "027641081087", "7", 0, "3.4.5.6", "027641081087"],
            ["ces8", 0, 0, "3.4.5.6", "027641081087", "8", 0, "3.4.5.6", "027641081087"],
            ["ces9", 0, 0, "3.4.5.6", "027641081087", "9", 0, "3.4.5.6", "027641081087"],
            ["ces10", 0, 0, "3.4.5.6", "027641081087", "1", 0, "3.4.5.6", "027641081087"],
            ["ces11", 0, 0, "3.4.5.6", "027641081087", "1", 0, "3.4.5.6", "027641081087"],
            ["ces12", 0, 0, "3.4.5.6", "027641081087", "2", 0, "3.4.5.6", "027641081087"],
            ["ces13", 0, 0, "3.4.5.6", "027641081087", "3", 0, "3.4.5.6", "027641081087"],
            ["ces14", 0, 0, "3.4.5.6", "027641081087", "4", 0, "3.4.5.6", "027641081087"],
            ["ces15", 0, 0, "3.4.5.6", "027641081087", "5", 0, "3.4.5.6", "027641081087"],
            ["ces16", "", 0, "3.4.5.6", "027641081087", "6", 0, "3.4.5.6", "027641081087"],
            ["ces17", 0, 0, "3.4.5.6", "027641081087", "7", 0, "3.4.5.6", "027641081087"],
            ["ces18", 0, 0, "3.4.5.6", "027641081087", "8", 0, "3.4.5.6", "027641081087"],
            ["ces19", 0, 0, "3.4.5.6", "027641081087", "9", 0, "3.4.5.6", "027641081087"],
        ]
    }()
}

extension ListViewController: NSTableViewDataSource, NSTableViewDelegate {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return list.count
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn else { return nil }

        let item = tableView.tableColumns.firstIndex(of: tableColumn)
        let array = list[row]

        let identifier = NSUserInterfaceItemIdentifier("one")
        var cell = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView
        if cell == nil {
            let textField = NNTextField.create(.zero, placeholder: "")
            textField.alignment = .center
            textField.isTextAlignmentVerticalCenter = true

            cell = NSTableCellView()
            cell?.identifier = identifier
            cell?.textField = textField
            cell?.addSubview(textField)
        }

        if let item = item {
            cell?.textField?.stringValue = "\(array[item])"
        }
        return cell
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = NNTableRowView()
        rowView.backgroundColor = NSColor.yellow
        return rowView
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
        DDLog(tableColumn)
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
    }

    func tableView(_ tableView: NSTableView, toolTipFor cell: NSCell, rect: NSRectPointer, tableColumn: NSTableColumn?, row: Int, mouseLocation: NSPoint) -> String {
        guard let tableColumn = tableColumn else { return "" }
        let item = tableView.tableColumns.firstIndex(of: tableColumn)
        return "{\(row),\(item ?? 0)}"
    }

    func tableView(_ tableView: NSTableView, shouldShowCellExpansionFor tableColumn: NSTableColumn?, row: Int) -> Bool {
        return true
    }

    func tableView(_ tableView: NSTableView, shouldTrackCell cell: NSCell, for tableColumn: NSTableColumn?, row: Int) -> Bool {
        return true
    }

    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        if edge == .trailing {
            let action = NSTableViewRowAction(style: .destructive, title: "DEMO") { _, _ in
                print("点击了DEMO")
            }
            action.backgroundColor = NSColor.orange

            let action2 = NSTableViewRowAction(style: .destructive, title: "DEMO1") { _, _ in
                print("点击了DEMO1")
            }
            action2.backgroundColor = NSColor.red
            return [action, action2]
        }

        if edge == .leading {
            let action = NSTableViewRowAction(style: .destructive, title: "AAA") { _, _ in
                print("点击了AAA")
            }
            action.backgroundColor = NSColor.orange

            let action2 = NSTableViewRowAction(style: .destructive, title: "BBB") { _, _ in
                print("点击了BBB")
            }
            action2.backgroundColor = NSColor.red
            return [action, action2]
        }
        return []
    }
}
