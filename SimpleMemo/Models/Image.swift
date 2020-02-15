//
//  Image.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/15.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import Foundation
import RealmSwift

enum Type: Int {
  case url
  case camera
  case album
}

class Image: Object {
  @objc dynamic var data: Data? = nil // optionals supported
  @objc dynamic var url: String? = nil
  dynamic var type: Type = .album
}
