//
//  NetworkMocker.swift
//  Movie TimeTests
//
//  Created by Arpit Singh on 29/01/23.
//
//


import Foundation

class DataTaskMock: URLSessionDataTask {

  var closure: () -> Void = {}

  override func resume() {
    closure()
  }

}

final class NetworkMocker: URLSession {

   var data: Data?
   var response: URLResponse?
   var error: Error?

   enum ResponseType {
        case successFormServer(HTTPURLResponse)
        case successWithData(Data)
        case error(Error)
    }

   static var response: ResponseType = .error(MockError.internalServerError)

  override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    let mockUrl = URL(string: "http://mock_url.com")!
    let dataTask = DataTaskMock()
    dataTask.closure =  {
        switch NetworkMocker.response {
        case .error(let error):
            if case .serverWithRes(let data) =  error as? MockError {
                let status = HTTPURLResponse(url: mockUrl, statusCode: 400, httpVersion: nil, headerFields: nil)
                completionHandler(data, status, error)
            } else {
                completionHandler(nil,nil, error)
            }
        case .successFormServer(let httpRes):
            completionHandler(nil, httpRes, MockError.internalServerError)
        case .successWithData(let res):
            let status = HTTPURLResponse(url:mockUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
            completionHandler(res,status, nil)
        }
    }
    return dataTask
  }
 
}

extension NetworkMocker {

    enum MockError: Error {
        case noNetwork
        case internalServerError
        case serverWithRes(Data)
    }

    static func responseWithFailure(withError: MockError) {
        NetworkMocker.response = NetworkMocker.ResponseType.error(withError)
    }

    static func responseWithJsonValue(json: Data) {
        NetworkMocker.response = NetworkMocker.ResponseType.successWithData(json)
    }

    static func responseWithStatusCode(url: URL,code: Int) {
        NetworkMocker.response = NetworkMocker.ResponseType.successFormServer(HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!)
    }
}
