//
//  Image.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/15.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import Foundation
import RealmSwift

class AttachedImage: Object {
  @objc dynamic var data: Data? = nil // optionals supported
  @objc dynamic var url: String? = nil
  
  enum `Type` {
    case url
    case data
  }
  var type: Type {
    return (data != nil) ? .data : .url
  }
}
