//
//  OMDBRemoteClientAPI.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//
import Combine
import Foundation
class OMDBRemoteClientAPI: MovieListRemoteAPI {
 
    private let networkSession: NetworkLayer
    
    init(networkSession: NetworkLayer = NetworkLayer()) {
        self.networkSession  = networkSession
    }
    
    
    func getMovieBy(word: String?, year: Int?, page: Int = 1) -> AnyPublisher<MovieRes, Error> {
       
        // keeping under OMDB page limit
        let currentPage = min(max(page, 1),100)
        
        var query = ["type": "movie","page": "\(currentPage)"]
        
        if let year = year {
            query["y"] = String(year)
        } else {
            query["y"] = "2000"
        }
        
        if let searchQuery = word {
            query["s"] = searchQuery
        } else {
            query["s"] = "love"
        }
        
        let request = OMDBRequestBuilder(queries: query)
        return networkSession
            .fetch(request: request, errorRes: OMDBError.self)
            .map({ (res: OMDBResponse) -> MovieRes in
                return res
            })
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

