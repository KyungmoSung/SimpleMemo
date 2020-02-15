//
//  Memo.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/15.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import Foundation
import RealmSwift

class Memo: Object {
  @objc dynamic var title: String = ""
  @objc dynamic var content: String = ""
  let images: List<Image> = List<Image>()
  @objc dynamic var category: Category? = nil
  @objc dynamic var createDate: Date = Date()
  @objc dynamic var updateDate: Date = Date()
}
