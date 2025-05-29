//
//  MockMovieServiceTest.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 29/05/25.
//

import Foundation
import ModuloServiceMovie

@testable import AmorPorFilmesSeries

public class MockMovieServiceTest: MovieServiceProtocol {
    public    var nowPlayingResult: Result<[Movie], any Error>?
    public var upcomingResult: Result<[Movie], any Error>?
    public var recentlyWatchedResult: Result<[Movie], any Error>?
    
    init(nowPlayingResult: Result<[Movie], any Error>? = nil,
         upcomingResult: Result<[Movie], any Error>? = nil,
         recentlyWatchedResult: Result<[Movie], any Error>? = nil) {
        self.nowPlayingResult = nowPlayingResult
        self.upcomingResult = upcomingResult
        self.recentlyWatchedResult = recentlyWatchedResult
    }
    
    public func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        if let result = nowPlayingResult {
            completion(result)
        }
    }
    
    public func fetchUpcomingMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        if let result = upcomingResult {
            completion(result)
        }
    }
    
    public func fetchRecentlyWatchedMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        if let result = recentlyWatchedResult {
            completion(result)
        }
    }
}
