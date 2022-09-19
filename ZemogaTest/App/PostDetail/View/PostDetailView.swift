//
//  PostDetailView.swift
//  ZemogaTest
//
//  Created by Byron Mejia on 9/17/22.
//

import UIKit

final class PostDetailView: UIView {
    
    let post: Post
    
    private enum Section: CaseIterable {
        case main
    }
    
    private typealias DataSource = UITableViewDiffableDataSource<Section, Comment>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Comment>
    
    init(post: Post) {
        self.post = post
        super.init(frame: .zero)
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var commentListView: UITableView = {
        let list = UITableView(frame: .zero, style: .insetGrouped)
        list.translatesAutoresizingMaskIntoConstraints = false
        list.showsVerticalScrollIndicator = false
        list.layer.cornerRadius = 10
        return list
    }()
    
    private lazy var captionUser: PostDetailDescriptionView = {
        return PostDetailDescriptionView(title: "Author")
    }()
    
    private lazy var captionPost: PostDetailDescriptionView = {
        return PostDetailDescriptionView(title: "Post")
    }()
    
    private lazy var captionComment: PostDetailDescriptionView = {
        PostDetailDescriptionView(title: "Comments")
    }()
    
    private lazy var userName: PostDetailDescriptionView = {
        return PostDetailDescriptionView(title: "Name")
    }()
    
    private lazy var userEmail: PostDetailDescriptionView = {
        return PostDetailDescriptionView(title: "Email")
    }()
    
    private lazy var titlePost: PostDetailDescriptionView = {
        return PostDetailDescriptionView(title: "Title")
    }()
    
    private lazy var descriptionPost: PostDetailDescriptionView = {
        return PostDetailDescriptionView(title: "Description")
    }()
    
    func configure(user: User?) {
        
        userName.setText(user?.name ?? "")
        userEmail.setText(user?.email ?? "")
    }
    
    private func setUI() {
        titlePost.setText(post.title ?? "")
        descriptionPost.setText(post.body ?? "")
    }
    
    // MARK: Diffable data source
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(tableView: commentListView) { [unowned self] _, _, comment -> UITableViewCell in
            
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            var configuration = cell.defaultContentConfiguration()
            
            configuration.text = comment.name
            configuration.secondaryText = comment.body
            cell.contentConfiguration = configuration
            
            return cell
        }
        return dataSource
    }()
    
    func applySnapshot(comment: [Comment]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems(comment, toSection: $0) }
        dataSource.apply(snapshot)
    }
}

extension PostDetailView: ViewCodeProtocol {
    
    func setupHierarchy() {
        containerStackView.addArrangedSubview(captionUser)
        containerStackView.addSpacing(8)
        containerStackView.addArrangedSubview(userName)
        containerStackView.addSpacing(8)
        containerStackView.addArrangedSubview(userEmail)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(captionPost)
        containerStackView.addSpacing(8)
        containerStackView.addArrangedSubview(titlePost)
        containerStackView.addSpacing(8)
        containerStackView.addArrangedSubview(descriptionPost)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(captionComment)
        containerStackView.addSpacing(18)
        containerStackView.addArrangedSubview(commentListView)
        
        scrollView.addSubview(containerStackView)
        addSubview(scrollView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -30),
            containerStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            containerStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            containerStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            commentListView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            commentListView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func additionalSetup() {
        backgroundColor = .tertiarySystemBackground
        setUI()
    }
}
