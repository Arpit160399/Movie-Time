//
//  MovieListRemoteAPITest.swift
//  Movie TimeTests
//
//  Created by Arpit Singh on 29/01/23.
//
import Combine
@testable import Movie_Time
import XCTest
final class MovieListRemoteAPITest: XCTestCase {
    
    private var task = Set<AnyCancellable>()
    private let timeOut = 2.5
    private var movieListRemoteAPI: MovieListRemoteAPI?
    private let clientMocker = OMDBMockImplementation()

    override func setUpWithError() throws {
        try super.setUpWithError()
        movieListRemoteAPI = OMDBRemoteClientAPI(networkSession: clientMocker.getNetworkLayer())
    }
    
    func testMovieWithEmptyData() throws {
        let exp = XCTestExpectation(description: " Get Empty Movie List")
        clientMocker.createEmptyJsonResponse()
        movieListRemoteAPI?
            .getMovieBy(word: nil, year: nil, page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    exp.fulfill()
                    var message = error.localizedDescription
                    if let localerror = error as? LocalError {
                        message = localerror.localizedDescription
                    }
                    print(error)
                    XCTFail("Request failed with an error : \(message)")
                }
            }, receiveValue: { movies in
                exp.fulfill()
                XCTAssertTrue(movies.count == 0, "got movies list instead of an empty list")
            })
            .store(in: &task)
        wait(for: [exp], timeout: timeOut)
    }

    func testMovieListWithResponse() throws {
        let exp = XCTestExpectation(description: " Get all Movie List")
        clientMocker.createDemoJsonResponse()
        movieListRemoteAPI?
            .getMovieBy(word: "Air", year: 2000, page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    exp.fulfill()
                    var message = error.localizedDescription
                    if let localerror = error as? LocalError {
                        message = localerror.localizedDescription
                    }
                    XCTFail("Request failed with an error : \(message)")
                }
            }, receiveValue: { movies in
                exp.fulfill()
                XCTAssertTrue(movies.count > 0, "failed to get any movie list")
            })
            .store(in: &task)
        wait(for: [exp], timeout: timeOut)
    }

    func testMovieListWithError() throws {
        let exp = XCTestExpectation(description: " Get an error instead of movie list")
        clientMocker.createErrorResponse()
        movieListRemoteAPI?
            .getMovieBy(word: nil, year: nil, page: 100)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    exp.fulfill()
                    XCTAssertNotNil(error, "expected an error but found it nil")
                }
            }, receiveValue: { _ in
                exp.fulfill()
                XCTFail("expected an error instead value was published")
            })
            .store(in: &task)
        wait(for: [exp], timeout: timeOut)
    }


}
