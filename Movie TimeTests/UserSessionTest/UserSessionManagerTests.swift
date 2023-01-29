//
//  UserSessionManagerTest.swift
//  Movie TimeTests
//
//  Created by Arpit Singh on 27/01/23.
//
import Combine
import XCTest
import LocalAuthentication
@testable import Movie_Time

final class UserSessionManagerTest: XCTestCase {
    
    // MARK: - Property
    private var userSessionStore: SessionManager?
    private let userSessionDataMock = UserSessionMockDataStack()
    private var task = Set<AnyCancellable>()
    private let timeOut = 0.5
    
    // MARK: - Method
    override func setUpWithError() throws {
        try super.setUpWithError()
        userSessionStore = SessionStore.sessionManagerFactory()
    }

    override func tearDownWithError() throws {
        userSessionStore = nil
        try super.tearDownWithError()
    }
    
    fileprivate func getSessionStoreWith(context: LAContext = LAContext()) -> SessionManager {
        let fileStore = FileUserSessionStore(url: Bundle(for: type(of: self)).url(forResource: "testAuth", withExtension: "json"))
        let sessionStore = SessionStore(encoder: UserDataCoder(),
                                        context: context,
                                        dataLayer: fileStore)
        return sessionStore
    }
    
    fileprivate func mockKeyStore(data: Data) {
            SecItemDelete(KeyItem().getItems())
            let keyItem = KeyItemWithData(data: data, context: LAContext())
            SecItemAdd(keyItem.getItems(), nil)
    }

    
    
    func testCreatingUserSession() throws {
        let exp = expectation(description: " User Successfully Login")
        let auth = UserSessionMockDataStack().constantUserAuth()
        SecItemDelete(KeyItem().getItems())
        getSessionStoreWith()
            .createUserSession(info: auth)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Failed to login the user due to: \(error.localizedDescription)")
                    exp.fulfill()
                }
            }, receiveValue: { session in
                exp.fulfill()
                XCTAssertTrue(session.user.email == auth.userEmail,"Login Operation Failed")
            }).store(in: &task)
        
        wait(for: [exp], timeout: timeOut)
    }
    
    func testSignUpUser() throws {
        let exp = expectation(description: " create new New User ")
        let user = userSessionDataMock.getTestUser()
        SecItemDelete(KeyItem().getItems())
        userSessionStore?
            .signUp(user: user)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("unable create new user because of : \(error.localizedDescription)")
                    exp.fulfill()
                }
            }, receiveValue: { session in
                exp.fulfill()
                XCTAssertTrue(session.user.email == user.email,"SignUp Operation Failed")
            }).store(in: &task)
        
        wait(for: [exp], timeout: timeOut)
    }
    
    func testClearUserSession() throws {
        let exp = expectation(description: " Successfully LogOut Current User ")
        
        userSessionStore?
            .clearUserSession()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Failed to logout user because of : \(error.localizedDescription)")
                    exp.fulfill()
                }
            }, receiveValue: {
                exp.fulfill()
            }).store(in: &task)
        
        wait(for: [exp], timeout: timeOut)
    }
    
    private func testForDifferentAuthCase(_ sessionStore: SessionManager, _ exp: XCTestExpectation, _ authCase: AuthCase, _ tempSession: Session) throws {
        sessionStore
            .getUserSession()
            .sink(receiveCompletion: { completion in
                if case .failure(let error)  = completion {
                    XCTFail("unable to get current session because of : \(error.localizedDescription)")
                    exp.fulfill()
                }
            }, receiveValue: { session in
                exp.fulfill()
                if authCase == .failure , session != nil  {
                    XCTFail("To perform user validation")
                } else if authCase == .success {
                    
                    guard let currentSession = session else {
                        XCTFail("To fetch session data from session store")
                        return
                    }
                    
                    XCTAssertTrue(tempSession.user.email == currentSession.user.email,
                                  "Failed to fetch correct user session")
                }
                
            }).store(in: &task)
    }
    
    private func testGetUserSessionWithSession() throws {
        var expectations = [XCTestExpectation]()
        let tempSession = UserSessionMockDataStack().getTestUserSession()
        guard let data = UserDataCoder().encode(userData: tempSession) else {
            XCTFail("User data failed to encode")
            return
        }
        mockKeyStore(data: data)
        
        for authCase in AuthCase.allCases {
            
            let exp = expectation(description: " get current user session with auth case \(authCase.rawValue)")
            expectations.append(exp)
            let sessionStore = getSessionStoreWith(context: authCase.getLAContext())
            
            try testForDifferentAuthCase(sessionStore, exp, authCase, tempSession)
        }
        
        wait(for: expectations, timeout: timeOut)

    }
    
    private func testGetUserSessionWithoutSession() throws {
        SecItemDelete(KeyItem().getItems())
        let exp = expectation(description: " get current user session without initial login")
        
        userSessionStore?
            .getUserSession()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unable to get status of user current session status due to:  \(error.localizedDescription)")
                    exp.fulfill()
                }
            }, receiveValue: { session in
                exp.fulfill()
                XCTAssertNil(session,"unexpected session generated")
            }).store(in: &task)
        
        wait(for: [exp], timeout: timeOut)
    }
    
    func testGetUserSession() throws {
        try testGetUserSessionWithoutSession()
        try testGetUserSessionWithSession()
    }

}
