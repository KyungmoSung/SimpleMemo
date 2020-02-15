//
//  RealmManager.swift
//  SimpleMemo
//
//  Created by Kyungmo on 2020/02/15.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager {
  static let shared = RealmManager()
  
  private var realm: Realm
  
  private init() {
     realm = try! Realm()
  }
  
  func add(_ objects: [Object]) {
    try? realm.write {
      realm.add(objects)
    }
  }

  func update(_ block: @escaping() -> Void) {
    try? realm.write(block)
  }

  func delete(_ items: [Object]) {
    try? realm.write {
      realm.delete(items)
    }
  }
}
