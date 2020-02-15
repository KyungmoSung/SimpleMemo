//
//  Category.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/15.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name = ""
  @objc dynamic var createDate = Date()
}
