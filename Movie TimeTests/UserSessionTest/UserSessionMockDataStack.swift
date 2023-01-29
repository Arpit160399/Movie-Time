//
//  UserSessionMockDataStack.swift
//  Movie TimeTests
//
//  Created by Arpit Singh on 28/01/23.
//

import Foundation
@testable import  Movie_Time
class UserSessionMockDataStack {
    
    private func generateEmail() -> String {
        return  "test\(Int.random(in: 100..<200))@gmail.com"
    }
    private func generatePassword() -> String {
        return "rx\(Int.random(in: 10...255))pj"
    }
    
    public func getTestUser() -> RegisterUser {
       return RegisterUser(name: "test", email: generateEmail(), password: generatePassword())
    }
    
    public func constantUserAuth() -> UserAuth {
        UserAuth(userEmail: "test202@gmail.com", password: "rx79pj")
    }
    
    public func getTestUserAuth() -> UserAuth {
        return UserAuth(userEmail: generateEmail(), password: generatePassword())
    }
    
    public func getTestUserSession() -> Session {
        let user = UserSession(name: "test", email: generateEmail())
        return .init(user: user, sessionCreated: Date().timeIntervalSince1970)
    }
    
    public func getData(_ session: Session? = nil) -> Data {
        let session = session == nil ? getTestUserSession() : session
        guard let session = session,
              let data = try? JSONEncoder().encode(session) else { return Data() }
        return data
    }
    
}
