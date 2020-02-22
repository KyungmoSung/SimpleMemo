//
//  StringExtension.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/22.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import Foundation

extension String {
  var localized: String {
    return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
  }
}
