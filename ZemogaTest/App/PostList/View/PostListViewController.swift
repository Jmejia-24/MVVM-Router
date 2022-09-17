//
//  PostListViewController.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/10/22.
//

import UIKit
import Combine

final class PostListViewController: UITableViewController {
    
    private enum Section: CaseIterable {
        case main
    }
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Post>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Post>
    private var subscription: AnyCancellable?
    private let viewModel: PostListViewModel
    
    init(viewModel: PostListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindUI()
    }
    
    // MARK: - Private methods
    
    private func setUI() {
        view.backgroundColor = .white
        title = "Posts"
        viewModel.loadData()
    }
    
    private func bindUI() {
        
        subscription = viewModel.postListSubject.sink { [unowned self] completion in
            switch completion {
            case .finished:
                print("Received completion in VC", completion)
            case .failure(let error):
                presentAlert(with: error)
            }
        } receiveValue: { [unowned self] posts in
            applySnapshot(posts: posts)
        }
    }
    
    // MARK: Diffable data source

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(tableView: tableView) { [unowned self] _, _, post -> UITableViewCell in

            let cell = UITableViewCell()
            var configuration = cell.defaultContentConfiguration()
            
            configuration.text = post.title?.capitalized
            cell.contentConfiguration = configuration

            return cell
        }
        return dataSource
    }()
    
    private func applySnapshot(posts: [Post]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(posts, toSection: $0) }
        dataSource.apply(snapshot)
    }
}
