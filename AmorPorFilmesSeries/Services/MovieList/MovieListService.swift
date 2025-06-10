//
//  MovieListService.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 28/05/25.
//

import Foundation
import ModuloServiceMovie

class MovieListService: MovieServiceProtocol {
    let service = NetworkService.shared
    public static let shared = MovieListService()
    
    func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            Task {
                await self?.fetchNowPlayingMoviesWithTask(completion: { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let movies):
                            completion(.success(movies))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                })
            }
        }
    }
    
    func fetchUpcomingMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            Task {
                await self?.fetchUpcomingMoviesWithTask(completion: { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let movies):
                            completion(.success(movies))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                })
            }
        }
    }
    
    func fetchRecentlyWatchedMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            Task {
                await self?.fetchRecentlyWatchedMoviesWithTask(completion: { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let movies):
                            completion(.success(movies))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                })
            }
        }
    }
    
    func fetchNowPlayingMoviesWithTask(completion: @escaping (Result<[Movie], Error>) -> Void) async {
        let request = APIRequest(path: "now_playing", method: .get)
        do {
            let response: Cover<Movie> = try await service.request(request)
            completion(.success(response.results))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchUpcomingMoviesWithTask(completion: @escaping (Result<[Movie], Error>) -> Void) async {
        let request = APIRequest(path: "top_rated", method: .get)
        do {
            let response: Cover<Movie> = try await service.request(request)
            completion(.success(response.results))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchRecentlyWatchedMoviesWithTask(completion: @escaping (Result<[Movie], Error>) -> Void) async {
        let request = APIRequest(path: "upcoming", method: .get)
        do {
            let response: Cover<Movie> = try await service.request(request)
            completion(.success(response.results))
        } catch {
            completion(.failure(error))
        }
    }
    
}
