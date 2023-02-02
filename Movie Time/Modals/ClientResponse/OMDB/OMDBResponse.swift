//
//  OMDBResponse.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//

import Foundation
struct OMDBResponse: MovieRes {
  
    var search: [Movie]
    var totalResults: Int
    var totalPage: Int { 0 }
    var response: Bool
    
    enum CodingKeys: String,CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.search = try container.decode([Movie].self, forKey: .search)
        
        if let totalResultNumber = try? Int(container.decode(String.self, forKey: .totalResults)) {
            self.totalResults = totalResultNumber
        } else {
            self.totalResults = 0
        }
       
        if let bool = try? Bool(container.decode(String.self, forKey: .totalResults)) {
            self.response = bool
        } else {
            self.response = false
        }
    }
}
