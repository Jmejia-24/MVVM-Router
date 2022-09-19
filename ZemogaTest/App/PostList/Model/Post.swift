//
//  Post.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/10/22.
//

import Foundation

struct Post: Codable, Hashable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?

    var isFavorite: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "\(id ?? 0)")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(id ?? 0)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case id = "id"
        case title = "title"
        case body = "body"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        body = try values.decodeIfPresent(String.self, forKey: .body)
    }
}
