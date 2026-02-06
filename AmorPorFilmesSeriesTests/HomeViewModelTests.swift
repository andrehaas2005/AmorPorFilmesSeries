//
//  HomeViewModelTests.swift
//  AmorPorFilmesSeriesTests
//
//  Created by Andre  Haas on 29/05/25.
//

import XCTest
@testable import AmorPorFilmesSeries
import ModuloServiceMovie

class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var movieServiceTest: MockMovieService!

    override func setUp() {
        super.setUp()
        movieServiceTest = MockMovieService()
        viewModel = HomeViewModel(movieService: movieServiceTest)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchHomeData_setsIsLoadingCorrectly() {
        let expectation = XCTestExpectation(description: "isLoading should be false after data fetching")

        // When
        viewModel.isLoading.bind { isLoading in
            if isLoading == false {
                expectation.fulfill()
            }
        }
        viewModel.fetchData()
        XCTAssertTrue(viewModel.isLoading.value ?? false, "isLoading should be true when fetching starts")

        wait(for: [expectation], timeout: 5)
//        XCTAssertFalse(viewModel.isLoading.value ?? true, "isLoading should be false after fetching completes")
    }

  

   

 
}

// Crie mocks vazios para ActorService e SerieService para o setUp() não falhar
class MockActorServiceTest: ActorServiceProtocol {
    var famousActorsResult: Result<[Actor], any Error>?

    init(famousActorsResult: Result<[Actor], any Error>? = nil) {
        self.famousActorsResult = famousActorsResult
    }

    func fetchFamousActors(completion: @escaping (Result<[Actor], any Error>) -> Void) {
        if let result = famousActorsResult {
            completion(result)
        }
    }
}

public struct Actor: Decodable, Equatable {
    public let id: Int
    public let name: String?

    public init(id: Int, name: String? = nil) {
        self.id = id
        self.name = name
    }
}

protocol ActorServiceProtocol: AnyObject {
    func fetchFamousActors(completion: @escaping (Result<[Actor], any Error>) -> Void)
}

class MockSerieServiceTest: SerieServiceProtocol {
    var lastWatchedSeriesResult: Result<[Serie], any Error>?

    init(lastWatchedSeriesResult: Result<[Serie], any Error>? = nil) {
        self.lastWatchedSeriesResult = lastWatchedSeriesResult
    }

    func fetchLastWatchedSeriesEpisodes(completion: @escaping (Result<[Serie], any Error>) -> Void) {
        if let result = lastWatchedSeriesResult {
            completion(result)
        }
    }
}

public struct Serie: Decodable, Equatable {
    public let id: Int
    public let name: String?

    public init(id: Int, name: String? = nil) {
        self.id = id
        self.name = name
    }
}

protocol SerieServiceProtocol: AnyObject {
    func fetchLastWatchedSeriesEpisodes(completion: @escaping (Result<[Serie], any Error>) -> Void)
}
