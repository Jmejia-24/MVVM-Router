//
//  PostDetailDescriptionView.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/17/22.
//

import UIKit

final class PostDetailDescriptionView: UIView {
    
    private let title: String
    private let value: String?
    
    init(title: String, value: String? = nil) {
        self.title = title
        self.value = value
        super.init(frame: .zero)
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 17)
        label.text = title
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = value
        label.numberOfLines = 0
        return label
    }()
    
    func setText(_ text: String) {
        valueLabel.text = text
    }
}

extension PostDetailDescriptionView: ViewCodeProtocol {
    
    func setupHierarchy() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        addSubview(containerView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func additionalSetup() {
        backgroundColor = .clear
    }
}
