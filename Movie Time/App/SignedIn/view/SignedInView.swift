//
//  SignedInView.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//

import Combine
import UIKit
class SignedInView: UIView {
    
    private let logoutButton: ActiveButton = {
        let button = ActiveButton()
        button.setTitle(StringResource.signOutTitle)
        button.activeColor = ColorResource.highlight
        return button
    }()
    
    private let header = HeaderView()
    private let padding: CGFloat = 15
    private let loaderHeight: CGFloat = 30
    private var size: Int = 0
    private lazy var tableview = UITableView(frame: .zero,style: .grouped)
    private let subject = PassthroughSubject<SignedInViewRequestState, Never>()
    private let activityLoader = UIActivityIndicatorView(style: .large)
    private var loaderHeightConstraint: NSLayoutConstraint?
    private var tableViewBottom: NSLayoutConstraint?
    
    // table view datasource
    private let datasource = SignedInDataSource()
    
    fileprivate func tabelViewConfiguration() {
        tableview.backgroundColor = ColorResource.backgroundColor
        tableview.delegate = self
        tableview.dataSource = datasource
        tableview.separatorStyle = .none
        tableview.sectionHeaderHeight = 170
        tableview.contentInset = .init(top: 0, left: 0, bottom: loaderHeight + (2 * padding), right: 0)
        tableview.register(MovieCardTableViewCell.self, forCellReuseIdentifier: MovieCardTableViewCell.cellID)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorResource.backgroundColor
        tabelViewConfiguration()
        setupLogoutButton()
        setupTableView()
        setupActivityView()
    }
    
    public func getSignedInPublisher() -> AnyPublisher<SignedInViewRequestState,Never>{
        return subject.eraseToAnyPublisher()
    }
    
    public func update( _ list: [Movie]) {
        datasource.updata(list)
        size = datasource.getSize()
        tableview.reloadData()
    }
    
    private func setupLogoutButton() {
        addSubview(logoutButton)
        logoutButton.cornerRadius = 15
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.topConstraint(safeAreaLayoutGuide.topAnchor, padding: padding)
            .rightConstraint(rightAnchor, padding: -padding * 1.2)
            .setWidth(100)
            .setHeight(30)
        logoutButton.addAction(.init(handler: { _ in
            self.logoutRequest()
        }), for: .touchUpInside)
    }
    
    private func setupTableView() {
        addSubview(tableview)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.topConstraint(logoutButton.bottomAnchor,padding: padding * 2)
            .leftConstraint(leftAnchor)
            .rightConstraint(rightAnchor)
            .bottomConstraint(bottomAnchor)
    }
    
    private func setupActivityView() {
        addSubview(activityLoader)
        activityLoader.color = ColorResource.appBlack
        activityLoader.translatesAutoresizingMaskIntoConstraints = false
        activityLoader.leftConstraint(leftAnchor)
            .rightConstraint(rightAnchor)
            .bottomConstraint(safeAreaLayoutGuide.bottomAnchor)
        loaderHeightConstraint = activityLoader.heightAnchor.constraint(equalToConstant: loaderHeight)
        loaderHeightConstraint?.isActive = true
        activityLoader.isHidden = true
    }
    
    public func startLoading() {
        loaderHeightConstraint?.isActive = false
        loaderHeightConstraint?.constant = loaderHeight
        activityLoader.startAnimating()
        activityLoader.isHidden = false
        updateLayout()
    }
    
    public func stopLoading() {
        loaderHeightConstraint?.isActive = false
        loaderHeightConstraint?.constant = loaderHeight
        activityLoader.isHidden = true
        activityLoader.stopAnimating()
        updateLayout()
    }
    
    
    fileprivate func updateLayout() {
        loaderHeightConstraint?.isActive = true
        UIView.animate(withDuration: 0.3, delay: 0, animations: { self.layoutIfNeeded() })
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHeading(_ name: String) {
        header.setGetting(name)
    }
    
    private func logoutRequest() {
        subject.send(.logout)
    }
}
// Table View delegate
extension SignedInView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        header.backgroundColor = ColorResource.backgroundColor
        return header
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (size - 1) {
            subject.send(.nextPage)
        }
    }

}
