//
//  PostListCoordinator.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/10/22.
//

import UIKit

final class PostListCoordinator: Coordinator {

    var model: Any?
    var navigationController: UINavigationController?
    weak var transitionDelegate: TransitionDelegate?
    
    private lazy var primaryViewController: UIViewController = {
        let viewModel = PostListViewModel()
        viewModel.transitionDelegate = transitionDelegate
        let viewController = PostListViewController(viewModel: viewModel)
        return viewController
    }()
    
    func start() {
        if navigationController?.viewControllers.isEmpty == false {
            navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(primaryViewController, animated: false)
    }
}
