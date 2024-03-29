//
//  UIColorExtension.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/17.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit

extension UIColor {

  /// 16진수 Color코드 적용
  convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
  }
  
  static var smBackground: UIColor {
    if #available(iOS 11.0, *) {
      return UIColor(named: "lightGreyBackground")!
    } else {
      return UIColor(hexString: "#EAEAEA")
    }
  }
  
  static var smPlaceholder: UIColor {
    if #available(iOS 11.0, *) {
      return UIColor(named: "textPlaceholder")!
    } else {
      return UIColor(hexString: "#6D797A")
    }
  }
  
  static var smText: UIColor {
    if #available(iOS 13.0, *) {
      return .label
    } else {
      return .darkText
    }
  }
  
  static var smBarButtonItemTint: UIColor {
    if #available(iOS 11.0, *) {
      return UIColor(named: "barButtonItemTint")!
    } else {
      return .black
    }
  }
}
