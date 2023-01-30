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
    
    // MARK: - Method
    init(sessionManager: SessionManager,
         makeOnBoardingViewController: @escaping () -> OnBoardingViewController) {
        self.sessionManager = sessionManager
        self.makeOnBoardingViewController = makeOnBoardingViewController
        super.init(nibName: nil, bundle: nil)
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
        launchView.startLoading {
            self.getCurrentUserSession()
        }
    }
    
    
    fileprivate func getCurrentUserSession() {
        sessionManager
        .getUserSession()
        .receive(on: DispatchQueue.main)
        .sink { complete in
            if case .failure(let error) = complete {
                self.present(error: error)
           }
        } receiveValue: { session in
            self.presentNextFlowWith(session: session)
        }.store(in: &task)
    }
    
    
    fileprivate func presentNextFlowWith(session: Session?) {
        let onBoardingViewController = makeOnBoardingViewController()
        onBoardingViewController.modalPresentationStyle = .fullScreen
        self.present(onBoardingViewController, animated: true)
    }
    
}
