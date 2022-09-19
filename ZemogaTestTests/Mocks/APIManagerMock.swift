//
//  APIManagerMock.swift
//  ZemogaTestTests
//
//  Created by Byron Mejia on 9/19/22.
//

import Combine
import Foundation

@testable import ZemogaTest

class APIManagerMock {
    
}

extension APIManagerMock: PostListStore {
    func fetchPost() -> Future<[Post], Failure> {
        return Future { promise in
            guard let urlPath = Bundle(for: APIManagerMock.self).url(forResource: "posts", withExtension: "json"),
                  let jsonString = (try? String(contentsOf: urlPath, encoding: .utf8)),
                  let data = jsonString.data(using: .utf8),
                  let detail = (try? JSONDecoder().decode([Post].self, from: data))
            else {
                promise(.failure(.decodingError))
                return }
            promise(.success(detail))
        }
    }
}
