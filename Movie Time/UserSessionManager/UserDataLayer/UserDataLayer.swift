//
//  UserDataLayer.swift
//  Movie Time
//
//  Created by Arpit Singh on 28/01/23.
//

import Foundation
import Combine

protocol UserDataLayer {
    
    /// register new user into system
    /// - Parameter user: contains all required user fields for
    /// - Returns: an publisher with response value being current created use details
    func create(user: RegisterUser) -> AnyPublisher<UserSession,Error>
    
    /// Authenticate already existing user into system
    /// - Parameter user: contains user important credentials required for user authentication.
    /// - Returns: an publisher with response value being the matching user detail with pass auth details.
    func login(user: UserAuth) ->  AnyPublisher<UserSession,Error>
}
