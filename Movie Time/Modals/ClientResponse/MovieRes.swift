//
//  MovieRes.swift
//  Movie Time
//
//  Created by Arpit Singh on 02/02/23.
//

import Foundation
protocol MovieRes: Decodable {
    var search: [Movie] { get  }
    var totalPage: Int { get }
    var totalResults: Int { get }
}

extension MovieRes {
    var totalPage: Int  { 0 }
    var totalResults: Int { 0 }
}
