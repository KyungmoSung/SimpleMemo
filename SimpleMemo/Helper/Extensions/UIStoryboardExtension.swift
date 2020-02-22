//
//  UIStoryboardExtension.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/22.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit

extension UIStoryboard {
  func instantiateVC<T: UIViewController>() -> T? {
    // get a class name and demangle for classes in Swift
    if let name = NSStringFromClass(T.self).components(separatedBy: ".").last {
      return instantiateViewController(withIdentifier: name) as? T
    }
    return nil
  }

}
