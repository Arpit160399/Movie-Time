//
//  UserDataEncoder.swift
//  Movie Time
//
//  Created by Arpit Singh on 28/01/23.
//

import Foundation

protocol UserDataEncoding {
    func encode(userData: Session) -> Data?
    func decode(data: Data) -> Session?
}
