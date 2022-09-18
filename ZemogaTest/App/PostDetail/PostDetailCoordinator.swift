//
//  PostDetailCoordinator.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/17/22.
//

import UIKit

final class PostDetailCoordinator: Coordinator {

    var model: Any?
    var navigationController: UINavigationController?
    weak var transitionDelegate: TransitionDelegate?

    var primaryViewController: UIViewController {
        // NOTE: TREATING THIS MODEL AS DEPENCY WHICH IS WHY FORCE CASTIN HERE
        let viewModel = PostDetailViewModel(post: model as! Post)
        let detailViewController = PostDetailViewController(viewModel: viewModel)
        return detailViewController
    }

    func start() {
        navigationController?.pushViewController(primaryViewController, animated: true)
    }
}
