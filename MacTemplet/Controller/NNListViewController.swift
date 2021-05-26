//
//  NNListViewController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/12/19.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit
import SwiftExpand


class NNListViewController: NSViewController {

    let list: [[String]] = [
                            ["名称","IP","状态","状态1","状态2",],
                            ["ces1","3.4.5.6","027641081087","1","3.4.5.6",],
                            ["ces2","3.4.5.6","027641081087","2","3.4.5.6",],
                            ["ces3","3.4.5.6","027641081087","3","3.4.5.6",],
                            ["ces4","3.4.5.6","027641081087","4","3.4.5.6",],
                            ["ces5","3.4.5.6","027641081087","5","3.4.5.6",],
                            ["ces6","3.4.5.6","027641081087","6","3.4.5.6",],
                            ["ces7","3.4.5.6","027641081087","7","3.4.5.6",],
                            ["ces8","3.4.5.6","027641081087","8","3.4.5.6",],
                            ["ces9","3.4.5.6","027641081087","9","3.4.5.6",],
                            ["ces10","3.4.5.6","027641081087","9","3.4.5.6",],
                            ["ces11","3.4.5.6","027641081087","1","3.4.5.6",],
                            ["ces12","3.4.5.6","027641081087","2","3.4.5.6",],
                            ["ces13","3.4.5.6","027641081087","3","3.4.5.6",],
                            ["ces14","3.4.5.6","027641081087","4","3.4.5.6",],
                            ["ces15","3.4.5.6","027641081087","5","3.4.5.6",],
                            ["ces16","3.4.5.6","027641081087","6","3.4.5.6",],
                            ["ces17","3.4.5.6","027641081087","7","3.4.5.6",],
                            ["ces18","3.4.5.6","027641081087","8","3.4.5.6",],
                            ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        setupTableView()
        view.addSubview(tableView.enclosingScrollView!)        
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        tableView.enclosingScrollView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
    }
    
    // MARK: - funtions
    
    func setupTableView() {
        var columnTitles = ["columeOne", "columeTwo", "columeThree",]
        columnTitles = list.first!
        columnTitles.forEach { (value) in
            let column = NSTableColumn.create(identifier: value, title: value)
            self.tableView.addTableColumn(column)
        }
    }
    
    // MARK: - lazy
    
    lazy var tableView: NNTableView = {
//        let view = NNTableView(frame: self.view.bounds)
        let view = NNTableView.create(self.view.bounds)
        /// NSTableColumn resizingMask 效果优先于 columnAutoresizingStyle
//        view.columnAutoresizingStyle = .uniformColumnAutoresizingStyle

        view.dataSource = (self as NSTableViewDataSource)
        view.delegate = (self as NSTableViewDelegate)
        return view
    }()
    
}


extension NNListViewController: NSTableViewDataSource, NSTableViewDelegate {

 
    func numberOfRows(in tableView: NSTableView) -> Int {
        return list.count - 1;
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn else { return nil }
        tableColumn.resizingMask = .userResizingMask;//手动调整宽度

        let item = tableView.tableColumns.firstIndex(of: tableColumn)
//        let columnID = tableColumn.identifier
                
        let array = list[row + 1]
        
//        let identifier = "one"
//        let cell = NSTableCellView.makeView(tableView: tableView, identifier: identifier, owner: self)
        let cell = tableView.makeView(for: NSTableCellView.self)
        
        cell.textField?.stringValue = "row: \(row)"
        cell.textField?.stringValue = "row: \(array[row])"
                
        if cell.viewWithTag(100) != nil {
            let textField: NNTextField = (cell.viewWithTag(100) as! NNTextField)
            textField.stringValue = "\(array[item!])"

        } else {
            let textField = NNTextField.create(cell.bounds, placeholder: "--")
            textField.alignment = .center
            textField.isTextAlignmentVerticalCenter = true
            cell.addSubview(textField)

            textField.stringValue = "\(array[item!])"
        }
        return cell
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let rowView = NNTableRowView()
        rowView.strokeColor = NSColor.red
        rowView.fillColor = NSColor.green

        return rowView;
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        guard let rowView = tableView.rowView(atRow: row, makeIfNecessary: false) else { return true}
//        let rowView = tableView.rowView(atRow: row, makeIfNecessary: false)
        rowView.selectionHighlightStyle = .regular
        rowView.isEmphasized = false;
        
        return true;
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        DDLog(tableColumn.identifier)
    }
  
    func tableViewSelectionDidChange(_ notification: Notification) {
//        DDLog(notification)
    }
    
    func tableView(_ tableView: NSTableView, toolTipFor cell: NSCell, rect: NSRectPointer, tableColumn: NSTableColumn?, row: Int, mouseLocation: NSPoint) -> String {
        guard let tableColumn = tableColumn else { return "" }
        let item = tableView.tableColumns.firstIndex(of: tableColumn)
        let result = "\(row),\(item ?? 0)"
        return result
    }
    
    func tableView(_ tableView: NSTableView, shouldShowCellExpansionFor tableColumn: NSTableColumn?, row: Int) -> Bool {
        return true
    }
    
    func tableView(_ tableView: NSTableView, shouldTrackCell cell: NSCell, for tableColumn: NSTableColumn?, row: Int) -> Bool {
        return true
    }
    
}
