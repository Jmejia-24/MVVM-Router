//
//  Company.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 10/5/22.
//

import Foundation

struct Company: Codable {
    let name: String?
    let catchPhrase: String?
    let bs: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case catchPhrase = "catchPhrase"
        case bs = "bs"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        catchPhrase = try values.decodeIfPresent(String.self, forKey: .catchPhrase)
        bs = try values.decodeIfPresent(String.self, forKey: .bs)
    }
}
