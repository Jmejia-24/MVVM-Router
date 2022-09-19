//
//  TestPostListViewModel.swift
//  ZemogaTestTests
//
//  Created by Byron Mejia on 9/19/22.
//

import XCTest
@testable import ZemogaTest

class TestPostListViewModel: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testLoadPosts() throws {
        let postStore: PostListStore = APIManagerMock()
        let viewModel = PostListViewModel(store: postStore)
        viewModel.loadData()
        let posts = try awaitPublisher(viewModel.postListSubject)
        XCTAssertFalse(posts.isEmpty)
    }
}
