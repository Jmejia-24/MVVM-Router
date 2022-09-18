//
//  ViewCodeProtocol.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/17/22.
//

import Foundation

protocol ViewCodeProtocol {
    func setupHierarchy()
    func setupConstraints()
    func additionalSetup()
    func buildView()
}

extension ViewCodeProtocol {

    func buildView() {
        setupHierarchy()
        setupConstraints()
        additionalSetup()
    }

    func additionalSetup() {}
}
