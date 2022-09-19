//
//  PostListTest.swift
//  ZemogaTestUITests
//
//  Created by Byron Mejia on 9/19/22.
//

import XCTest

class PostListTest: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    func testTableView() {
        let cell = app.tables.firstMatch.cells.element(boundBy: 3)
        cell.tap()
        app.navigationBars["Detail"].buttons["Posts"].tap()
    }
}
