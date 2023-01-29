//
//  SessionManager.swift
//  Movie Time
//
//  Created by Arpit Singh on 27/01/23.
//
import Combine
import Foundation
/// Provides Interface for user session management.
protocol SessionManager {
    
    /// creates new user session by validating users pass credentials
    /// - Parameter info: contains user important credentials required for user authentication
    /// - Returns: an publisher with response value being new user session on success.
    func createUserSession(info: UserAuth) -> AnyPublisher<Session,Error>
    
    /// provides the currently active user session
    /// - Returns: an publisher with response value being current use session if is there otherwise nil
    func getUserSession() -> AnyPublisher<Session?,Error>
    
    /// register new user using required information and creates an new session.
    ///- Parameter user: contains all required user detail for signup
    ///- Returns: an publisher with response value being current use session if is there otherwise nil
    func signUp(user: RegisterUser) -> AnyPublisher<Session,Error>
    
    /// clear the currently active user session.
    func clearUserSession() -> AnyPublisher<Void,Error>
}

typealias Secret = String
