//
//  Session.swift
//  Movie Time
//
//  Created by Arpit Singh on 27/01/23.
//

import Foundation

struct Session: Codable {
    let user: UserSession
    let sessionCreated: TimeInterval
}

struct UserSession: Codable {
    let name: String
    let email: String
}

extension UserSession {
     init(user: User)  {
     name = user.name
     email = user.email
    }
}
