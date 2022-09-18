//
//  PostDetailViewModel.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/16/22.
//

import UIKit
import Combine

final class PostDetailViewModel {
    let post: Post
    let store: PostDetailStore
    
    let userSubject = CurrentValueSubject<User?, Failure>(nil)
    let commentsSubject = PassthroughSubject<[Comment], Failure>()
    
    private var disposeBag = Set<AnyCancellable>()
    
    init(post: Post, store: PostDetailStore = APIManager()) {
        self.post = post
        self.store = store
    }
    
    func loadComments() {
        let receivedPosts = { [unowned self] (comments: [Comment]) -> Void in
            DispatchQueue.main.async {
                commentsSubject.send(comments)
            }
        }
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch  completion {
                case .finished:
                    break
                case .failure(let failure):
                    commentsSubject.send(completion: .failure(failure))
            }
        }
        
        store.readComments(for: post.id ?? 1)
            .sink(receiveCompletion: completion, receiveValue: receivedPosts)
            .store(in: &disposeBag)
    }
    
    func loadUser() {
        
        let recievedUser = { [unowned self] (user: User) -> Void in
            DispatchQueue.main.async {
                userSubject.send(user)
            }
        }
        
        let completion = { [unowned self] (completion: Subscribers.Completion<Failure>) -> Void in
            switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    userSubject.send(completion: .failure(failure))
            }
        }
        
        store.readUser(for: post.userId ?? 1)
            .sink(receiveCompletion: completion, receiveValue: recievedUser)
            .store(in: &disposeBag)
    }
}
