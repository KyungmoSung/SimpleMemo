//
//  DesignableView.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/18.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableView: UIView {

  @IBInspectable var circular: Bool = false {
    didSet {
      if self.circular {
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.masksToBounds = true
      }
    }
  }

  @IBInspectable var cornerRadius: Double {
    get {
      return Double(self.layer.cornerRadius)
    } set {
      self.layer.cornerRadius = CGFloat(newValue)
    }
  }
  @IBInspectable var borderWidth: Double {
    get {
      return Double(self.layer.borderWidth)
    }
    set {
      self.layer.borderWidth = CGFloat(newValue)
    }
  }
  @IBInspectable var borderColor: UIColor? {
    get {
      return UIColor(cgColor: self.layer.borderColor!)
    }
    set {
      self.layer.borderColor = newValue?.cgColor
    }
  }
  @IBInspectable var shadowColor: UIColor? {
    get {
      if let color = layer.shadowColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.shadowColor = color.cgColor
      } else {
        layer.shadowColor = nil
      }
    }
  }

  @IBInspectable var shadowOpacity: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }

  @IBInspectable var shadowOffset: CGPoint {
    get {
      return CGPoint(x: layer.shadowOffset.width, y: layer.shadowOffset.height)
    }
    set {
      layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
    }

  }

  @IBInspectable var shadowBlur: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue / 2.0
    }
  }

  @IBInspectable var shadowSpread: CGFloat = 0 {
    didSet {
      if shadowSpread == 0 {
        layer.shadowPath = nil
      } else {
        let dx = -shadowSpread
        let rect = bounds.insetBy(dx: dx, dy: dx)
        layer.shadowPath = UIBezierPath(rect: rect).cgPath
      }
    }
  }
}
