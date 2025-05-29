//
//  MockMovieServiceTest.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 29/05/25.
//


//
//  MockMovieServiceTest.swift
//  AmorPorFilmesSeriesTests
//
//  Created by Andre Haas on 29/05/25.
//

import Foundation
import ModuloServiceMovie

class MockMovieServiceTest: MovieServiceProtocol {
    var nowPlayingResult: Result<[Result], any Error>?
    var upcomingResult: Result<[Movie], any Error>?
    var recentlyWatchedResult: Result<[Movie], any Error>?

    init(nowPlayingResult: Result<[Movie], any Error>? = nil,
         upcomingResult: Result<[Movie], any Error>? = nil,
         recentlyWatchedResult: Result<[Movie], any Error>? = nil) {
        self.nowPlayingResult = nowPlayingResult
        self.upcomingResult = upcomingResult
        self.recentlyWatchedResult = recentlyWatchedResult
    }

    func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        if let result = nowPlayingResult {
            completion(result)
        }
    }

    func fetchUpcomingMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        if let result = upcomingResult {
            completion(result)
        }
    }

    func fetchRecentlyWatchedMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        if let result = recentlyWatchedResult {
            completion(result)
        }
    }
}
