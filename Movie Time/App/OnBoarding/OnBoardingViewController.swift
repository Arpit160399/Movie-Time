//
//  onBoardIngViewController.swift
//  Movie Time
//
//  Created by Arpit Singh on 30/01/23.
//

import UIKit
import Combine

class OnBoardingViewController: UIViewController {

    //MARK: - Properties
    private let onBoarding = OnBoardingView()
    private var task = Set<AnyCancellable>()
    private let sessionManger: SessionManager
    
    // session state subject
    private let sessionStateSubject: PassthroughSubject<Session,Never>
    
    //MARK: - Methods
    init(sessionManger: SessionManager,
         sessionStateSubject: PassthroughSubject<Session,Never>) {
        self.sessionManger = sessionManger
        self.sessionStateSubject = sessionStateSubject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onBoarding.pinToParent(view: view)
        registerToOnBoardingPublisher()
        // Do any additional setup after loading the view.
    }
 
    fileprivate func registerToOnBoardingPublisher() {
        onBoarding
        .getValuePublisher()
        .sink { value in
            switch value {
               
                case .signUp(let register):
                self.performSignUp(register)
                case .login(let auth):
                self.performLogin(auth)
            }
        }.store(in: &task)
    }
    
    // User Registration
    func performSignUp(_ register: RegisterUser) {
        guard register.name.count >= 3 else
        { onBoarding.setErrorTo(.name); return }
        
        guard validated(email: register.email, password: register.password) else
        { return }
      
        sessionManger
        .signUp(user: register)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure(let error) = completion {
                self.present(error: error)
                self.onBoarding.processComplete()
            }
        } receiveValue: { session in
            self.onBoarding.processComplete()
            self.dismiss(animated: true) {
                self.sessionStateSubject.send(session)
            }
        }.store(in: &task)
    }
    
    // User Login
    func performLogin(_ user: UserAuth) {
        guard validated(email: user.userEmail, password: user.password) else
        { return }
        sessionManger
        .createUserSession(info: user)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case .failure(let error) = completion {
                self.present(error: error)
                self.onBoarding.processComplete()
            }
        } receiveValue: { session in
            self.onBoarding.processComplete()
            self.dismiss(animated: true) {
                self.sessionStateSubject.send(session)
            }
        }.store(in: &task)
    }

}

// MARK: - Forme validation
extension OnBoardingViewController {
    
    func validated(email: String ,password: Secret) -> Bool {
        guard isValidEmailA(email) else {
            onBoarding.setErrorTo(.email)
            return false
        }
        guard isPassword(password) else {
            onBoarding.setErrorTo(.password)
            return false
        }
        return true
  }
    
  func isValidEmailA(_ email: String) -> Bool {
     let emailPattern = #"^\S+@\S+\.\S+$"#
     let result = email.range(
            of: emailPattern,
            options: .regularExpression)

      return result != nil
  }
    
    func  isPassword(_ input: String) -> Bool {
        if input.count >= 6 {
          return true
        } else {
          presentErrorWith(message: StringResource.passwordValidationError)
          return false
        }
    }
    
}
