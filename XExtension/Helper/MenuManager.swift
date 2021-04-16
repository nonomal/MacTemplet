//
//  MenuManager.swift
//  XcodeWay
//
//  Created by Khoa Pham on 22/07/16.
//  Copyright © 2016 Fantageek. All rights reserved.
//

import Foundation

struct MenuManager {

  static let navigators: [Navigator] = [
    ProjectFolderNavigator(),
    DerivedDataFolderNavigator(),
    ProvisioningProfileFolderNavigator(),
    ArchivesFolderNavigator(),
    DeviceSupportFolderNavigator(),
    DoTermnalOpen(),
    DoPodInstall(),
    DoPodUpdate(),
    CleanDerivedData(),
    AboutNavigator()
  ]

  static func find(commandIdentifier: String) -> Navigator? {
    for navigator in navigators {
      if Helper.namespacedIdentifier(identifier: navigator.title) == commandIdentifier {
        return navigator
      }
    }

    return nil
  }
}
