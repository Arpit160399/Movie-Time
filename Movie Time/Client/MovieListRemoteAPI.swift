//
//  OMPB Rephandler.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//

import Foundation
import Combine

protocol MovieListRemoteAPI {
    func getMovieBy(word: String?,year: Int?,page: Int) -> AnyPublisher<MovieRes,Error>
}


