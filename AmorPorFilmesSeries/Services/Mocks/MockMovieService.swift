//
//  MockMovieService.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Services/MockMovieService.swift
import Foundation

class MockMovieService: MovieServiceProtocol {
    func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        getMockData { [weak self] result in
            completion(.success(result))
        }
    }
    
    func fetchUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        getMockData { [weak self] result in
            completion(.success(result))
        }
    }
    
    func fetchRecentlyWatchedMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        getMockData { [weak self] result in
            completion(.success(result))
        }
    }
    
    func getMockData(completion: @escaping ([Movie])-> Void) {
        DispatchQueue(label: "Mock").asyncAfter(deadline: .now() + 1.1, execute: {
            completion(Utilits.getObject("ListMoviesPopular"))
        })
    }
}
