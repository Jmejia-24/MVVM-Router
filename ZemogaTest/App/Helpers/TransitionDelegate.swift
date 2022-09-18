//
//  TransitionDelegate.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/10/22.
//

import Foundation

protocol TransitionDelegate: AnyObject {
    func process(transition: Transition, with model: Any?)
}

enum Transition {
    case showMainScreen
    case showPostDetail
}
