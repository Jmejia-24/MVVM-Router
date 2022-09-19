//
//  XCTestCase+AwaitPublisher.swift
//  ZemogaTestTests
//
//  Created by Byron Mejia on 9/19/22.
//

import XCTest
import Combine

extension XCTestCase {
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")
        
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        result = .failure(error)
                    case .finished:
                        break
                }
                
                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
                expectation.fulfill()
                
            }
        )
        
        waitForExpectations(timeout: timeout)
        cancellable.cancel()
        
        /// Here you can pass the original file and line number that
        /// this utility was called at, to tell XCTest to report
        /// any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )
        
        return try unwrappedResult.get()
    }
}
