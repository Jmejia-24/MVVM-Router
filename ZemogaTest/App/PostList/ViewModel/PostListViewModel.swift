//
//  PostListViewModel.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/10/22.
//

import UIKit
import Combine

final class PostListViewModel {
    weak var transitionDelegate: TransitionDelegate?
    
    let postListSubject = PassthroughSubject<[Post], Failure>()
    private var cancellables = Set<AnyCancellable>()
    private let store: PostListStore
    
    init(store: PostListStore = APIManager()) {
        self.store = store
    }
    
    func loadData() {
        let receivedPosts = { [unowned self] (posts: [Post]) -> Void in
            DispatchQueue.main.async {
                postListSubject.send(posts)
            }
        }
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch  completion {
                case .finished:
                    break
                case .failure(let failure):
                    postListSubject.send(completion: .failure(failure))
            }
        }
        
        store.fetchPost()
            .sink(receiveCompletion: completion, receiveValue: receivedPosts)
            .store(in: &cancellables)
    }
    
    func didTapItem(model: Post) {
        transitionDelegate?.process(transition: .showPostDetail, with: model)
    }
}
