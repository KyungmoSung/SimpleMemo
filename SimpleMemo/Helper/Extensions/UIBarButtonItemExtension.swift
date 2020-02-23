//
//  File.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/24.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
  @IBInspectable var accessibilityEnabled: Bool {
    get {
      return isAccessibilityElement
    }
    set {
      isAccessibilityElement = newValue
    }
  }

  @IBInspectable var accessibilityLabelText: String? {
    get {
      return accessibilityLabel
    }
    set {
      accessibilityLabel = newValue
    }
  }
}
