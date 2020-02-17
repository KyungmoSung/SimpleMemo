//
//  ReuseIdentifying.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/17.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import Foundation

protocol ReuseIdentifying {
  static var reuseIdentifier: String { get }
  static var nibName: String { get }
}

extension ReuseIdentifying {
  static var reuseIdentifier: String {
    return String(describing: Self.self)
  }

  static var nibName: String {
    return String(describing: Self.self)
  }
}

