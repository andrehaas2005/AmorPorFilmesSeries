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

    var mockMovieServiceTest: MockMovieServiceTest!
    var viewModel: HomeViewModel!
    var mockActorServiceTest: ActorServiceProtocol!

    override func setUp() {
        super.setUp()
        mockMovieServiceTest = MockMovieServiceTest()
        mockActorServiceTest = MockActorServiceTest()
        let mockSerieServiceTest = MockSerieServiceTest()
        viewModel = HomeViewModel(movieService: mockMovieServiceTest, actorService: mockActorServiceTest, serieService: mockSerieServiceTest)
    }

    override func tearDown() {
        viewModel = nil
        mockMovieServiceTest = nil
        super.tearDown()
    }

    func testFetchHomeData_setsIsLoadingCorrectly() {
        // Given
        mockMovieServiceTest.nowPlayingResult = .success(getMockMovie(1))
        mockMovieServiceTest.upcomingResult = .success(getMockMovie(1))

        // Não precisamos configurar os outros resultados do serviço para este teste

        let expectation = XCTestExpectation(description: "isLoading should be false after data fetching")

        // When
        viewModel.isLoading.bind { isLoading in
            if isLoading == false {
                expectation.fulfill()
            }
        }
        viewModel.fetchHomeData()
        XCTAssertTrue(viewModel.isLoading.value ?? false, "isLoading should be true when fetching starts")

        wait(for: [expectation], timeout: 5)
        XCTAssertFalse(viewModel.isLoading.value ?? true, "isLoading should be false after fetching completes")
    }

    func testFetchHomeData_loadsNowPlayingMoviesOnSuccess() {
        // Given
        let mockMovies = getMockMovie(2)
        mockMovieServiceTest.nowPlayingResult = .success(mockMovies)
        // Configurar resultados de sucesso para os outros serviços para evitar erros do mock
        mockMovieServiceTest.upcomingResult = .success([])
        mockMovieServiceTest.recentlyWatchedResult = .success([])
        let mockActorServiceTest = MockActorServiceTest(famousActorsResult: .success([]))
        let mockSerieServiceTest = MockSerieServiceTest(lastWatchedSeriesResult: .success([]))
        viewModel = HomeViewModel(movieService: mockMovieServiceTest, actorService: mockActorServiceTest, serieService: mockSerieServiceTest)

        let expectation = XCTestExpectation(description: "nowPlayingMovies should be populated")

        // When
        viewModel.nowPlayingMovies.bind { movies in
            if movies != nil {
                expectation.fulfill()
            }
        }
        viewModel.fetchHomeData()

        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(mockMovieServiceTest.nowPlayingResult, .success(mockMovies))
        XCTAssertEqual(viewModel.nowPlayingMovies.value, mockMovies)
    }

    func testFetchHomeData_setsErrorMessageOnNowPlayingFailure() {
        // Given
        let errorMessage = "Erro de rede simulado"
        mockMovieServiceTest.nowPlayingResult = .failure(NSError(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
        // Configurar resultados de sucesso para os outros serviços para evitar outros erros
        mockMovieServiceTest.upcomingResult = .success([])
        mockMovieServiceTest.recentlyWatchedResult = .success([])
        let mockActorServiceTest = MockActorServiceTest(famousActorsResult: .success([]))
        let mockSerieServiceTest = MockSerieServiceTest(lastWatchedSeriesResult: .success([]))
        viewModel = HomeViewModel(movieService: mockMovieServiceTest, actorService: mockActorServiceTest, serieService: mockSerieServiceTest)

        let expectation = XCTestExpectation(description: "errorMessage should be set on failure")

        // When
        viewModel.errorMessage.bind { message in
            if message != nil {
                expectation.fulfill()
            }
        }
        viewModel.fetchHomeData()

        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(viewModel.errorMessage.value, "Erro ao carregar filmes em cartaz: \(errorMessage)", "Error message should be set")
    }

    func getMockMovie(_ qtdaRegistro: Int) -> [Movie] {
        var result = [Movie]()
        for x in 0..<qtdaRegistro {
            result.append(Movie(adult: false, backdropPath: "/teste\(x)", genreIDS: [1,2,3], id: 1, originalLanguage: "Fime \(x)", originalTitle: "Filme \(x)", overview: "só texto", popularity: 9.0, posterPath: "/posterPath\(x)", releaseDate: "releaseDate", title: "title \(x)", video: true, voteAverage: 9.0, voteCount: 9))
        }
        return result
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
