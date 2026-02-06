//
//  PosterViewModelTests.swift
//  AmorPorFilmesSeriesTests
//
//  Created by Andre  Haas on 24/06/25.
//

import XCTest

@testable import AmorPorFilmesSeries

final class PosterViewModelTests: XCTestCase {
    
    var viewModel: MovieViewModelProtocol?
    var service: MovieServiceProtocol = NetworkAFMovieService.shared
    
    override func setUp() {
        super.setUp()
        viewModel = PosterViewModel(movieService: service)
    }
    
    func testNotNilViewModel() throws {
        XCTAssertNotNil(viewModel)
    }
    
    func testNotNilService() throws {
        XCTAssertNotNil(viewModel?.movieService)
    }
    
}

final class NetworkAFMovieServiceTests: XCTestCase {
    var service = NetworkAFMovieService.shared
    
    func testNetworkCallfetchNowPlayingMovies() throws {
        
        let e =  expectation(description: "fetchData")
        service.fetchNowPlayingMovies { result in
            switch result {
            case .success(let movies):
                print(movies)
                XCTAssertNotNil(movies)
            case .failure(let error):
                XCTFail("\(error)")
            }
            e.fulfill()
        }
        wait(for: [e], timeout: 5.0)
    }
    
    func testNetworkCallfetchUpcomingMovies() throws {
        
        let e =  expectation(description: "fetchData")
        service.fetchUpcomingMovies { result in
            switch result {
            case .success(let movies):
                print(movies)
                XCTAssertNotNil(movies)
            case .failure(let error):
                XCTFail("\(error)")
            }
            e.fulfill()
        }
        wait(for: [e], timeout: 5.0)
    }
    
    func testNetworkCallfetchRecentlyWatchedMovies() throws {
        
        let e =  expectation(description: "fetchData")
        service.fetchRecentlyWatchedMovies { result in
            switch result {
            case .success(let movies):
                print(movies)
                XCTAssertNotNil(movies)
            case .failure(let error):
                XCTFail("\(error)")
            }
            e.fulfill()
        }
        wait(for: [e], timeout: 5.0)
    }
}
