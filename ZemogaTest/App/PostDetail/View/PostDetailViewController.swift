//
//  PostDetailViewController.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/17/22.
//

import UIKit
import Combine

final class PostDetailViewController: UIViewController {
    private var subscription: AnyCancellable?
    private var subscriptionUser: AnyCancellable?
    private let viewModel: PostDetailViewModel
    private var contentView: PostDetailView?

    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        self.contentView = PostDetailView(post: viewModel.post)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        title = "Detail"
        view = contentView
        viewModel.loadUser()
        viewModel.loadComments()
        bindUserUI()
        bindCommentsUI()
    }
    
    private func bindUserUI() {
        subscriptionUser = viewModel.userSubject.sink { [unowned self] completion in
            switch completion {
            case .finished:
                print("Received completion in VC", completion)
            case .failure(let error):
                presentAlert(with: error)
            }
        } receiveValue: { [unowned self] user in
            contentView?.configure(user: user)
        }
    }
    
    private func bindCommentsUI() {
        subscription = viewModel.commentsSubject.sink { [unowned self] completion in
            switch completion {
            case .finished:
                print("Received completion in VC", completion)
            case .failure(let error):
                presentAlert(with: error)
            }
        } receiveValue: { [unowned self] comments in
            contentView?.applySnapshot(comment: comments)
        }
    }
}
