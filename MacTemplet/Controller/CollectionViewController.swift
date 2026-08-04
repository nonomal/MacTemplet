//
//  CollectionViewController.swift
//  MacTemplet
//
//  Created by Bin Shang on 2019/6/18.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import Cocoa
import SnapKit

@objcMembers
class CollectionViewController: NSViewController {

    private lazy var ctView: NNCollectionView = {
        let view = NNCollectionView(frame: view.bounds)
        view.collectionViewLayout = createFlowLayout()
        view.register(NSCTViewCellOne.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier("Slide"))
        view.isSelectable = true
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private var content: [[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer?.backgroundColor = NSColor.red.cgColor
        view.addSubview(ctView.enclosingScrollView!)
        dataSource()
        ctView.reloadData()
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        ctView.enclosingScrollView!.snp.makeConstraints { make in
            make.edges.equalTo(ctView.enclosingScrollView!.superview!)
        }
    }

    func dataSource() {
        let array0 = [
            NSImage.quickLookTemplateName, NSImage.bluetoothTemplateName, NSImage.iChatTheaterTemplateName,
            NSImage.slideshowTemplateName, NSImage.actionTemplateName, NSImage.smartBadgeTemplateName,
            NSImage.iconViewTemplateName, NSImage.listViewTemplateName, NSImage.columnViewTemplateName,
            NSImage.flowViewTemplateName, NSImage.pathTemplateName, NSImage.invalidDataFreestandingTemplateName,
            NSImage.lockLockedTemplateName, NSImage.lockUnlockedTemplateName, NSImage.goRightTemplateName,
            NSImage.goLeftTemplateName, NSImage.rightFacingTriangleTemplateName, NSImage.leftFacingTriangleTemplateName,
            NSImage.addTemplateName, NSImage.removeTemplateName, NSImage.revealFreestandingTemplateName,
            NSImage.followLinkFreestandingTemplateName, NSImage.enterFullScreenTemplateName,
            NSImage.exitFullScreenTemplateName, NSImage.stopProgressTemplateName,
            NSImage.stopProgressFreestandingTemplateName, NSImage.refreshTemplateName,
            NSImage.refreshFreestandingTemplateName, NSImage.bonjourName, NSImage.computerName,
            NSImage.folderBurnableName, NSImage.folderSmartName, NSImage.folderName, NSImage.networkName,
        ]

        let array1 = [
            NSImage.mobileMeName, NSImage.multipleDocumentsName, NSImage.userAccountsName,
            NSImage.preferencesGeneralName, NSImage.advancedName, NSImage.infoName,
            NSImage.fontPanelName, NSImage.colorPanelName, NSImage.userName,
            NSImage.userGroupName, NSImage.everyoneName, NSImage.userGuestName,
            NSImage.menuOnStateTemplateName,
        ]

        let array2 = [
            NSImage.menuMixedStateTemplateName, NSImage.applicationIconName, NSImage.trashEmptyName,
            NSImage.trashFullName, NSImage.homeTemplateName, NSImage.bookmarksTemplateName,
            NSImage.cautionName, NSImage.statusAvailableName, NSImage.statusPartiallyAvailableName,
            NSImage.statusUnavailableName, NSImage.statusNoneName, NSImage.shareTemplateName,
        ]

        let array3 = [
            NSImage.goRightTemplateName, NSImage.goLeftTemplateName,
            NSImage.rightFacingTriangleTemplateName, NSImage.leftFacingTriangleTemplateName,
        ]

        let array4 = [
            NSImage.addTemplateName, NSImage.removeTemplateName, NSImage.revealFreestandingTemplateName,
            NSImage.followLinkFreestandingTemplateName, NSImage.enterFullScreenTemplateName,
            NSImage.exitFullScreenTemplateName, NSImage.stopProgressTemplateName,
            NSImage.stopProgressFreestandingTemplateName, NSImage.refreshTemplateName,
            NSImage.refreshFreestandingTemplateName,
        ]

        let array5 = [
            NSImage.bonjourName, NSImage.computerName, NSImage.folderBurnableName,
            NSImage.folderSmartName, NSImage.folderName, NSImage.networkName,
        ]

        let array6 = [
            NSImage.mobileMeName, NSImage.multipleDocumentsName, NSImage.userAccountsName,
            NSImage.preferencesGeneralName, NSImage.advancedName, NSImage.infoName,
            NSImage.fontPanelName, NSImage.colorPanelName, NSImage.userName,
            NSImage.userGroupName, NSImage.everyoneName, NSImage.userGuestName,
            NSImage.menuOnStateTemplateName, NSImage.menuMixedStateTemplateName,
        ]

        let array7 = [
            NSImage.trashEmptyName, NSImage.trashFullName, NSImage.homeTemplateName,
            NSImage.bookmarksTemplateName, NSImage.cautionName, NSImage.statusAvailableName,
            NSImage.statusPartiallyAvailableName, NSImage.statusUnavailableName,
            NSImage.statusNoneName, NSImage.shareTemplateName,
        ]

        content = [array0, array1, array2, array3, array4, array5, array6, array7]
        ctView.reloadData()
    }

    func createFlowLayout() -> NSCollectionViewFlowLayout {
        let layout = NSCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = NSSize(width: 120, height: 120)
        layout.scrollDirection = .vertical
        layout.sectionInset = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
}

extension CollectionViewController: NSCollectionViewDataSource {

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        content.count
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        content[section].count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let list = content[indexPath.section]
        let string = list[indexPath.item]

        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("Slide"), for: indexPath) as! NSCTViewCellOne
        item.imgView.image = NSImage(named: string)
        item.label.stringValue = string
        return item
    }
}

extension CollectionViewController: NSCollectionViewDelegate {

    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    }
}

extension CollectionViewController: NSCollectionViewDelegateFlowLayout {
}
