//
//  APIManager.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/10/22.
//

import Foundation
import Combine

protocol PostListStore {
    func fetchPost() -> Future<[Post], Failure>
}

final class APIManager {
    static let serviceURL = "https://jsonplaceholder.typicode.com/"
}

extension APIManager: PostListStore {
    func fetchPost() -> Future<[Post], Failure> {
        let postPath = "posts"
        return Future { promise in
            guard let url = URL(string: APIManager.serviceURL + postPath) else {
                promise(.failure(.urlConstructError))
                return
            }
            
            // TODO: Add invalidate and Cancel functionality when a subscription to this future is completed or errored
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, case .none = error else { promise(.failure(.urlConstructError)); return }
                do {
                    let decoder = JSONDecoder()
                    let posts = try decoder.decode([Post].self, from: data)
                    promise(.success(posts))
                    
                } catch {
                    promise(.failure(.APIError(error)))
                }
            }
            task.resume()
        }
    }
}
