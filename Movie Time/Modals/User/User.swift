//
//  User.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//

import Foundation
struct User: Codable,Equatable {
    let name: String
    let email: String
    var password: Secret
}

extension User {
    init(data: RegisterUser,password: String) {
        self.name = data.name
        self.email = data.email
        self.password = password
    }
}
