//
//  MainViewController.swift
//  Movie Time
//
//  Created by Arpit Singh on 27/01/23.
//

import UIKit
import Combine
class MainViewController: UIViewController {
    
    // MARK: - Property
    private let sessionManager: SessionManager
    private let launchView = LaunchView()
    private var task = Set<AnyCancellable>()
    
    // onBoarding Factory
    private let makeOnBoardingViewController: () -> OnBoardingViewController
    
    // signed-in Factory
    private let makeSignedInViewController: (Session) -> SignedInViewController
    
    private var viewState: MainViewState = .launch
    
    // MARK: - Method
    init(sessionManager: SessionManager,
         sessionPublisher: AnyPublisher<Session,Never>,
         makeOnBoardingViewController: @escaping () -> OnBoardingViewController,
         makeSignedInViewController: @escaping  (Session) -> SignedInViewController) {
        self.sessionManager = sessionManager
        self.makeOnBoardingViewController = makeOnBoardingViewController
        self.makeSignedInViewController = makeSignedInViewController
        super.init(nibName: nil, bundle: nil)
        sessionPublisher
        .sink { _ in } receiveValue: { session in
            self.presentSignedInViewController(session)
        }.store(in: &task)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchView.pinToParent(view: view)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewState == .launch {
            launchView
                .startLoading {
                    self.getCurrentUserSession()
                }
        }
    }
    
    
    fileprivate func getCurrentUserSession() {
        sessionManager
        .getUserSession()
        .receive(on: DispatchQueue.main)
        .sink { complete in
            if case .failure(let error) = complete {
                self.present(error: error) {
                    self.presentOnBoardingViewController()
                }
           }
        } receiveValue: { session in
            self.presentNextFlowWith(session: session)
        }.store(in: &task)
    }
    
    
    fileprivate func presentOnBoardingViewController() {
        viewState = .onBoarding
        let onBoardingViewController = makeOnBoardingViewController()
        onBoardingViewController.modalPresentationStyle = .fullScreen
        self.present(onBoardingViewController, animated: true)
    }
    
    fileprivate func presentSignedInViewController(_ session: Session) {
        viewState = .launch
        let signedInViewController = makeSignedInViewController(session)
        signedInViewController.modalPresentationStyle = .fullScreen
        self.present(signedInViewController, animated: true)
    }
    
    fileprivate func presentNextFlowWith(session: Session?) {
        if let session = session {
            presentSignedInViewController(session)
        } else {
            presentOnBoardingViewController()
        }
    }
    
}
