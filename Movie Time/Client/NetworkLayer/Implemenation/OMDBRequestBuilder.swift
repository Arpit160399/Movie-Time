//
//  OMDBRequestBuilder.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//

import Foundation
class OMDBRequestBuilder: Requesting {
    
    // MARK: - properties
    
    /// To support different type of  HTTP  request methods
    enum HTTPMethod: String {
        case get
    }
    
    /// base url of OMDB API
    private var hostName: String {
         if let host = Bundle.main.object(forInfoDictionaryKey: "Host Name") as? String {
             return host
         } else {
             return ""
         }
     }
    /// OMDB API key
    private var apiKey: String {
        if let host = Bundle.main.object(forInfoDictionaryKey: "API Key") as? String {
            return host
        } else {
            return ""
        }
    }
    
    private let method: HTTPMethod
    
    private var urlComponent: URLComponents
    
    // MARK: - Methods

    init(method: HTTPMethod = .get,path: String? = nil ,queries: [String: String] = [:]) {
        self.method = method
        self.urlComponent = URLComponents()
        urlComponent.scheme = "http"
        urlComponent.host = self.hostName
        if let path = path {
            urlComponent.path = path
        }
        var queryItems = [URLQueryItem(name: "apikey", value: self.apiKey)]
        for query in queries {
            queryItems.append(.init(name: query.key, value: query.value))
        }
        urlComponent.queryItems = queryItems
    }
    
    
    func getRequest() -> URLRequest? {
        guard let url = urlComponent.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
