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

  /// 데이터 로드
  func objects<Element: Object>(_ type: Element.Type) -> Results<Element> {
    return realm.objects(type)
  }
  
  /// 데이터 추가
  func add(_ objects: [Object]) {
    try? realm.write {
      realm.add(objects)
    }
  }

  /// 데이터 수정
  func update(_ block: @escaping() -> Void) {
    try? realm.write(block)
  }

  /// 데이터 삭제
  func delete(_ items: [Object]) {
    try? realm.write {
      realm.delete(items)
    }
  }
}
