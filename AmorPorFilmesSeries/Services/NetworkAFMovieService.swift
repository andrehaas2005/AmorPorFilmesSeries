//
//  NetworkAFMovieService.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 23/06/25.
//

import Foundation
import Alamofire
import ModuloServiceMovie

class NetworkAFMovieService {
    static let shared = NetworkAFMovieService()
    
    public func request<T: Decodable>(_ request: APIMovieRequest, completion: @escaping (Result<T, Error>) -> Void) {
        
        let baseUrl = Configuration.baseAPIURL
        let apiKey = Configuration.apiKey
        if baseUrl.isEmpty || apiKey.isEmpty {
            print(#function)
            debugPrint("URL ou Api Key com erro!")
        }
        
        guard var urlComponents = URLComponents(string: baseUrl + request.path.rawValue),
//        guard var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/movie/upcoming"),
            
              let url = urlComponents.url else {
            
            return
        }
        
        
        urlComponents.queryItems = [
            URLQueryItem(name: "language", value: "pt-BR"),
            URLQueryItem(name: "region", value: "BR"),
            URLQueryItem(name: "page", value: "1")
        ]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        urlRequest.timeoutInterval = 30
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        AF.request(urlRequest)
            .validate()
            .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let success):
                let listMovie: T = success as T
                completion(.success(listMovie))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension NetworkAFMovieService: MovieServiceProtocol {
    func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        let apiMovie = APIMovieRequest(path: .nowPlaying, method: .get)
        
        self.request(apiMovie) { (response:Result<Cover<Movie>, Error>) in
            switch response {
                
            case .success(let cover):
                completion(.success(cover.results))
            case .failure(let error):
                print(#function, " ==> \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUpcomingMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        let apiMovie = APIMovieRequest(path: .upcoming, method: .get)
        
        self.request(apiMovie) { (response:Result<Cover<Movie>, Error>) in
            switch response {
                
            case .success(let cover):
                completion(.success(cover.results))
            case .failure(let error):
                print(#function, " ==> \(error.localizedDescription)")
            }
        }
    }
    
    func fetchRecentlyWatchedMovies(completion: @escaping (Result<[Movie], any Error>) -> Void) {
        let apiMovie = APIMovieRequest(path: .popular, method: .get)
        
        self.request(apiMovie) { (response:Result<Cover<Movie>, Error>) in
            switch response {
                
            case .success(let cover):
                completion(.success(cover.results))
            case .failure(let error):
                print(#function, " ==> \(error.localizedDescription)")
            }
        }
    }
    
    
}



public struct APIMovieRequest {
    
    let path: RouterMovie
    let method: HTTPMovieMethod
    let body: Data?
    let parameters: Parameters?
    
    public init(path: RouterMovie, method: HTTPMovieMethod, body: Data? = nil, parameters: Parameters? = nil) {
        self.path = path
        self.method = method
        self.body = body
        self.parameters = parameters
    }
}
