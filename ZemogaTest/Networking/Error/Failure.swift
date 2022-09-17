//
//  Failure.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/10/22.
//

import Foundation

enum Failure: Error {
    case decodingError
    case urlConstructError
    case APIError(Error)
    case statusCode
}
