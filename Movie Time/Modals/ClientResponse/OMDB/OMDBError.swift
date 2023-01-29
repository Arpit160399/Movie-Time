//
//  ErrorResponse.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//

import Foundation
class OMDBError: ResponseError {
   var response: Bool
   var error: String
        
   var localizedDescription: String { error }
    
    enum CodingKeys: String,CodingKey {
        case response = "Response"
        case error = "Error"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.response = try Bool(container.decode(String.self, forKey: .response)) ?? false
        self.error = try container.decode(String.self, forKey: .error)
    }
}
