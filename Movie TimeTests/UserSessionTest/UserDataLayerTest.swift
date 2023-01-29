//
//  UserDataLayerTest.swift
//  Movie TimeTests
//
//  Created by Arpit Singh on 29/01/23.
//
import Combine
import XCTest
@testable import Movie_Time
final class UserDataLayerTest: XCTestCase {
    
    private var task = Set<AnyCancellable>()
    private var userDataLayerForLogin: UserDataLayer?
    private var userDataLayer: UserDataLayer?
    private let limit = 0.4
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        userDataLayerForLogin = FileUserSessionStore(url: Bundle(for: type(of: self)).url(forResource: "testAuth", withExtension: "json"))
        userDataLayer = FileUserSessionStore()
    }
    
    func testLoginUser() throws {
        let exp = expectation(description: "Login the user")
        let auth = UserSessionMockDataStack().constantUserAuth()
        userDataLayerForLogin?
            .login(user: auth)
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("unable to login user due to: \(error.localizedDescription)")
                    exp.fulfill()
                }
            } receiveValue: { session in
                exp.fulfill()
                XCTAssertTrue(session.email == auth.userEmail,"Login Operation Failed")
            }.store(in: &task)
        wait(for: [exp], timeout: limit)
    }
  
    func testSignUpUser() throws {
        let exp = expectation(description: "SignUp as New User ")
        let register = UserSessionMockDataStack().getTestUser()
        userDataLayer?.create(user: register)
        .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTFail("unable create new user due to: \(error.localizedDescription)")
                exp.fulfill()
            }
        }, receiveValue: { session in
                exp.fulfill()
            XCTAssertTrue(session.email == register.email,"SignUp Operation Failed")
            }).store(in: &task)
        wait(for: [exp], timeout: limit)
    }


}
