//
//  Networking.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//

import Foundation
import Combine

typealias ResponseError = LocalError & Decodable

protocol Networking {
    func fetch<T: Decodable>(request: Requesting,errorRes: ResponseError.Type) -> AnyPublisher<T,Error>
}

protocol Requesting {
    func getRequest() -> URLRequest?
}
