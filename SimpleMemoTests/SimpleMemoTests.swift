//
//  SimpleMemoTests.swift
//  SimpleMemoTests
//
//  Created by Kyungmo on 2020/02/15.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import XCTest
import RealmSwift
import Nuke

@testable import SimpleMemo

class SimpleMemoTests: XCTestCase {
  var realm: Realm!
  var memo: Memo!
  
  override func setUp() {
    super.setUp()

    realm = try! Realm(
      configuration: Realm.Configuration(inMemoryIdentifier: self.name)
    )
    
    let urlImage = AttachedImage()
    urlImage.url = "https://kyungmosung.github.io/img/avatar.jpg"
    let dataImage = AttachedImage()
    dataImage.data = UIImage(named: "imagePlaceholder")?.pngData()
    memo = Memo(title: "title", content: "content", images: [urlImage, dataImage])
    
    try! realm.write {
      realm.add(memo)
    }
  }

  override func tearDown() {
    super.tearDown()

    try! realm.write {
      realm.deleteAll()
    }
  }

  /// DB저장 테스트
  func testSaveMemo() {
    let memos = realm.objects(Memo.self)
    XCTAssertEqual(memos.filter { $0.ID == self.memo.ID }.count, 1)
  }

  /// 메모 이미지 타입별 테스트
  func testMemoAttachImageType() {
    let memos = realm.objects(Memo.self)
    XCTAssertGreaterThan(memos.count, 0)
    
    for memo in memos {
      for image in memo.images {
        switch image.type {
        case .data:
          XCTAssertNotNil(image.data)
          XCTAssertNil(image.url)

          // 이미지 데이터 로딩
          XCTAssertNotNil(UIImage(data: image.data!))
        case .url:
          XCTAssertNotNil(image.url)
          XCTAssertNil(image.data)

          let imageURL = URL(string: image.url!)
          XCTAssertNotNil(imageURL)

          // 이미지 URL 로딩
          ImagePipeline.shared.loadImage(with: imageURL!) { result in
            switch result {
            case .success(let response):
              XCTAssertNotNil(response.image)
            case .failure(let error):
              XCTFail(error.localizedDescription)
            }
          }
        }
      }
    }
  }
}
