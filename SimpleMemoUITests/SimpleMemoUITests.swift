//
//  SimpleMemoUITests.swift
//  SimpleMemoUITests
//
//  Created by Kyungmo on 2020/02/15.
//  Copyright © 2020 kyungmo. All rights reserved.
//

import XCTest
@testable import SimpleMemo

class SimpleMemoUITests: XCTestCase {
  var app: XCUIApplication!
  
  override func setUp() {
    super.setUp()
    
    continueAfterFailure = false

    app = XCUIApplication()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testMemoList() {
    app.launch()

    for _ in 0 ..< 3 {
      app.buttons["gridBtn"].tap()
    }
  }
  
  func testAddMemo() {
    app.launch()
    app.buttons["addBtn"].tap()
    
    XCTAssertFalse(app.buttons["editBtn"].exists)
    XCTAssertFalse(app.buttons["deleteBtn"].exists)
    XCTAssertTrue(app.buttons["saveBtn"].exists)
    
    let titleTf = app.textFields["titleTf"]
    titleTf.tap()
    titleTf.typeText("Test title")
    
    let contentTv = app.textViews["contentTv"]
    contentTv.tap()
    contentTv.typeText("Test content")

    let imageCollectionView = app.collectionViews["imageCollectionView"]
    let cell = imageCollectionView.cells.element(matching: .cell, identifier: "attachImageSelectCell_0")
    cell.tap()
    
    app.buttons["외부 이미지(URL)"].tap()
    let imageUrlTf = app.textFields["imageUrlTf"]
    imageUrlTf.tap()
    imageUrlTf.typeText("https://kyungmosung.github.io/img/avatar.jpg")
    app.buttons["확인"].tap()
    
    app.buttons["추가"].tap()
  }
}
