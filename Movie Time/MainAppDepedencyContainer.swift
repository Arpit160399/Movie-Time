//
//  MainAppDepedencyContainer.swift
//  Movie Time
//
//  Created by Arpit Singh on 27/01/23.
//

import UIKit
import Combine

class MainAppDependencyContainer {
    
    private let sessionStore: SessionManager
    private let subject = PassthroughSubject<Session,Never>()
    
    init() {
        self.sessionStore = SessionStore.sessionManagerFactory()
    }
    
    public func makeMainViewController() -> MainViewController {
    
        let onBoardingViewControllerFactory = {
            self.makeOnBoardingViewController()
        }
        let signedInViewControllerFactory = { (session: Session) in
            self.makeSignedInViewController(session)
        }
        
        return MainViewController(sessionManager: sessionStore,
                                  sessionPublisher: subject.eraseToAnyPublisher(),
            makeOnBoardingViewController: onBoardingViewControllerFactory,
            makeSignedInViewController: signedInViewControllerFactory)
    }
    
    
    // OnBoard user
    public func makeOnBoardingViewController() -> OnBoardingViewController {
        return OnBoardingViewController(sessionManger: sessionStore,
                                        sessionStateSubject: subject)
    }
    
    //Signed_In
    public func makeSignedInViewController(_ session: Session) -> SignedInViewController {
        let omdbClient = OMDBRemoteClientAPI()
        let signedInViewController = SignedInViewController(session: session.user,
                                                movieRemoteApi: omdbClient)
        return signedInViewController
    }

}
