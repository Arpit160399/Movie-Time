//
//  SignedInViewController.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//

import UIKit
import Combine
class SignedInViewController: UIViewController {
    
    // MARK: - poperties
    
    private let session: UserSession
    private let sessionManager: SessionManager
    private let movieRemoteApi: MovieListRemoteAPI
    private var retry = false
    
    // view
    private let signedInView = SignedInView()
    
    
    private var task = Set<AnyCancellable>()
    private var currentPage: Int = 1
    private var year = 1990
    private var maxYearLimit = 2000
    
    // MARK: - methods
    
    init(session: UserSession,
         sessionManager: SessionManager,
         movieRemoteApi: MovieListRemoteAPI) {
        self.session = session
        self.movieRemoteApi = movieRemoteApi
        self.sessionManager = sessionManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        signedInView.pinToParent(view: view)
        signedInView.setHeading(session.name)
        signedInView.getSignedInPublisher()
            .sink { state in
                switch state {
                case .logout:
                    self.presentAlert()
                case .nextPage:
                    self.currentPage +=  1
                    self.requestMovieList(self.currentPage)
            }
        }.store(in: &task)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestMovieList(currentPage)
    }
    
    private func presentAlert()  {
        let alert = UIAlertController(title: StringResource.logoutTitle,
                                      message: StringResource.logoutMessage,
                                      preferredStyle: .actionSheet)
        alert.addAction(.init(title: StringResource.signOutTitle
                              , style: .destructive,handler: { _ in
            self.logoutUser()
        }))
        alert.addAction(.init(title: StringResource.cancel, style: .cancel))
        present(alert, animated: true)
    }
    
    // Get Movie List
    private func requestMovieList(_ page: Int) {
        signedInView.startLoading()
        movieRemoteApi.getMovieBy(word: "love", year: year, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [self] completion in
                if case .failure(let error)  = completion {
                    if case .responseWith(let res) = error as? NetworkLayer.NetworkError,
                        !retry,
                        res is OMDBError {
                        self.year = min(year + 1, self.maxYearLimit)
                        self.currentPage = 0
                        self.requestMovieList(0)
                        self.retry = true
                    } else {
                        self.present(error: error)
                    }
                    self.signedInView.stopLoading()
                }
            } receiveValue: { movies in
                    self.signedInView.update(movies)
                    self.signedInView.stopLoading()
                    self.retry = false
            }.store(in: &task)
    }
    
    // clear current user session
    private func logoutUser() {
        sessionManager.clearUserSession()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error ) = completion {
                    self.present(error: error)
                }
            } receiveValue: { _ in
                self.dismiss(animated: true)
        }.store(in: &task)
    }

}
