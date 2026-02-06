//
//  MovieService.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 12/06/25.
//

import Foundation
import ModuloServiceMovie

class MovieServiceOld: MovieServiceProtocol {
    
    static let shared = MovieService()
    let service: NetworkMovieService = {
       
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return NetworkMovieService(session: session)
    }()
    
    func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        
       let task = Task {
            do {
                let listMovies: Cover<Movie> =  try await service
                    .request(ModuloServiceMovie.APIMovieRequest(path: .nowPlaying, method: .get, body: nil))
                completion(.success(listMovies.results))
            }
        }
        task.cancel()
    }
    
    func fetchUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        Task {
            do {
                let listMovies: Cover<Movie> =  try await service
                    .request(ModuloServiceMovie.APIMovieRequest(path: .upcoming,
                                             method: .get))
                completion(.success(listMovies.results))
            }
        }
    }
    
    func fetchRecentlyWatchedMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
       Task {
            do {
                let listMovies: Cover<Movie> = try await service
                    .request(ModuloServiceMovie.APIMovieRequest(path: .popular,
                                             method: .get))
                completion(.success(listMovies.results))
            }
        }
    }
}
