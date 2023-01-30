//
//  MainAppDepedencyContainer.swift
//  Movie Time
//
//  Created by Arpit Singh on 27/01/23.
//

import UIKit

class MainAppDependencyContainer {
    
    private let sessionStore: SessionManager

    init() {
        self.sessionStore = SessionStore.sessionManagerFactory()
    }
    
    public func makeMainViewController() -> MainViewController {
        let onBoardingViewControllerFactory = {
            self.makeOnBoardingViewController()
        }
        return MainViewController(sessionManager: sessionStore,
                makeOnBoardingViewController: onBoardingViewControllerFactory)
    }
    
    
    // OnBoard user
    public func makeOnBoardingViewController() -> OnBoardingViewController {
        return OnBoardingViewController()
    }

}
