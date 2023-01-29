//
//  NetworkLayer.swift
//  Movie Time
//
//  Created by Arpit Singh on 29/01/23.
//

import Foundation
import Combine
class NetworkLayer: Networking {

    private let networkSession: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.networkSession = session
    }
    
    enum NetworkError: LocalError {
        case requestFailed(Error)
        case responseWith(LocalError)
        case networkFailure
        case HTTPRequestBuildFailed
        
        var localizedDescription: String {
            switch self {
            case .responseWith(let error ):
                return error.localizedDescription
            case .requestFailed(let error):
                return error.localizedDescription
            default:
                return ""
            }
        }
    }
    
    
    
    func fetch<T>(request: Requesting,errorRes: ResponseError.Type) -> AnyPublisher<T, Error> where T : Decodable {
        
        guard let urlRequest = request.getRequest() else {
            return Fail(error: NetworkError.HTTPRequestBuildFailed)
                    .eraseToAnyPublisher()
        }
    
        let decoder = JSONDecoder()
        
        func decodeErrorFrom(data: Data) throws -> Error {
            let error = try decoder.decode(errorRes.self,
                                      from: data)
            return NetworkError.responseWith(error)
        }
        
        return networkSession
               .dataTaskPublisher(for: urlRequest)
               .tryMap { output -> T in
                   guard let reps = output.response as? HTTPURLResponse else {
                       throw NetworkError.networkFailure
                   }
                   
                   if reps.statusCode == 200 {
                      do {
        
                           let data = try decoder.decode(T.self,
                                                         from: output.data)
                           return data
                           
                      } catch {
                         let error = try decodeErrorFrom(data: output.data)
                         throw error
                      }
                   } else {
                      let error = try decodeErrorFrom(data: output.data)
                      throw error
                  }
               }.mapError({ error in
               
                   guard let err = error as? NetworkError else {
                       return NetworkError.requestFailed(error)
                   }
                   return err
                   
               }).eraseToAnyPublisher()
    }
    
}
