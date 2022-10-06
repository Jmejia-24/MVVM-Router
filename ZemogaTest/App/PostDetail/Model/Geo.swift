//
//  Geo.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 10/6/22.
//

import Foundation

struct Geo: Codable {
    let lat: String?
    let lng: String?

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lng = try values.decodeIfPresent(String.self, forKey: .lng)
    }
}
