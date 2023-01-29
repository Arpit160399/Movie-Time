//
//  ClientMockImplementation.swift
//  Movie TimeTests
//
//  Created by Arpit Singh on 29/01/23.
//

import Foundation
@testable import Movie_Time
class OMDBMockImplementation {
         
    init() {}
    
    func getNetworkLayer() -> NetworkLayer {
        let network = NetworkLayer(session: NetworkMocker())
        return network
    }
    
    
    func createDemoJsonResponse() {
        guard let path = Bundle(for: type(of: self)).url(forResource: "FakeOMDBResponse", withExtension: "json"),
        let jsonData = try? Data(contentsOf: path) else { return }
        NetworkMocker.responseWithJsonValue(json: jsonData)
    }
    
    func createErrorResponse() {
         guard let path = Bundle(for: type(of: self)).url(forResource: "FakeOMDBError", withExtension: "json"),
         let jsonData = try? Data(contentsOf: path) else { return }
        NetworkMocker.responseWithFailure(withError: .serverWithRes(jsonData))
    }
    
    func createNoNetworkError() {
        NetworkMocker.responseWithFailure(withError: .noNetwork)
    }
    
    func createEmptyJsonResponse() {
        let testrespone = """
        {
            "Search": []
        }
        """
        let jsonData = Data(testrespone.utf8)
        NetworkMocker.responseWithJsonValue(json: jsonData)
    }
    
    
}
