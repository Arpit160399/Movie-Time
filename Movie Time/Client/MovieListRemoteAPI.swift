//
//  OMPB Rephandler.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//

import Foundation
import Combine
protocol MovieListRemoteAPI {
    func getMovieBy(word: String?,year: Int?,page: Int) -> AnyPublisher<[Movie],Error>
}

struct Movie: Decodable {
    var title: String
    var year: Int
    var imdbID: String
    var type: String
    var poster: URL
    
    enum CodingKeys: String,CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        if let year = try? container.decode(Int.self, forKey: .year) {
            self.year = year
        } else if let year = try? Int(container.decode(String.self, forKey: .year)) {
            self.year = year
        } else {
            self.year = 0
        }
        self.imdbID = try container.decode(String.self, forKey: .imdbID)
        self.type = try container.decode(String.self, forKey: .type)
        self.poster = try container.decode(URL.self, forKey: .poster)
    }
}

