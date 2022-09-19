//
//  PostListViewController.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/10/22.
//

import UIKit
import Combine

final class PostListViewController: UITableViewController {
    
    enum Section: String, CaseIterable {
        case favorites = "Favorite Posts"
        case post = "Posts"
    }
    
    private let viewModel: PostListViewModel
    private var subscription: AnyCancellable?
    private var dataSource: DataSource?
    
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
    
    private lazy var refreshBarButtonItem: UIBarButtonItem = {
        let action = UIAction { [unowned self] _ in
            viewModel.loadData()
            bindUI()
        }
        
        let button = UIBarButtonItem(systemItem: .refresh, primaryAction: action)
        return button
    }()
    
    private lazy var trashBarButtonItem: UIBarButtonItem = {
        let action = UIAction { [unowned self] _ in
            guard var snapshot = dataSource?.snapshot() else { return }
            let posts = snapshot.itemIdentifiers(inSection: .post)
            snapshot.deleteItems(posts)
            applySnapshot(posts: snapshot.itemIdentifiers)
            
        }
        
        let button = UIBarButtonItem(systemItem: .trash, primaryAction: action)
        button.tintColor = .red
        return button
    }()
    
    private func setUI() {
        view.backgroundColor = .tertiarySystemBackground
        title = "Posts"
        navigationItem.rightBarButtonItems  = [trashBarButtonItem, refreshBarButtonItem]
        viewModel.loadData()
        configureDataSource()
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
    
    private func favoriteButtonConfiguration(for post: Post) -> UIButton {
        let symbolName = post.isFavorite ? "star.fill" : "star"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = UIButton()
        
        let action = UIAction { [unowned self] _ in
            var selectedPost = post
            selectedPost.isFavorite.toggle()
            guard var snapshot = dataSource?.snapshot() else { return }
            snapshot.reloadItems([selectedPost])
            dataSource?.apply(snapshot, animatingDifferences: false)
            applySnapshot(posts: snapshot.itemIdentifiers)
        }
        
        button.addAction(action, for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.sizeToFit()
        return button
    }
}

extension PostListViewController {
    
    // MARK: Diffable data source
    
    class DataSource: UITableViewDiffableDataSource<Section, Post> {
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            Section.allCases[section].rawValue
        }
        
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let identifierToDelete = itemIdentifier(for: indexPath) {
                    var identifier = identifierToDelete
                    identifier.isFavorite = false
                    
                    var snapshot = self.snapshot()
                    snapshot.deleteItems([identifier])
                    apply(snapshot)
                }
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView) { [unowned self] _, _, post -> UITableViewCell? in
            let cell = UITableViewCell()
            cell.backgroundColor = .tertiarySystemBackground
            var configuration = cell.defaultContentConfiguration()
            
            configuration.text = post.title
            cell.contentConfiguration = configuration
            cell.accessoryView = favoriteButtonConfiguration(for: post)
            
            return cell
        }
    }
    
    private func applySnapshot(posts: [Post] = []) {
        let favorites = posts.filter { $0.isFavorite }
        let posts = posts.filter { !$0.isFavorite }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(favorites, toSection: .favorites)
        snapshot.appendItems(posts, toSection: .post)
        dataSource?.apply(snapshot)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = dataSource?.itemIdentifier(for: indexPath) else { return }
        viewModel.didTapItem(model: post)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
