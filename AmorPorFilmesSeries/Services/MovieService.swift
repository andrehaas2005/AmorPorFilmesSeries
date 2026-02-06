//
//  MovieService.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 13/08/25.
//

import Foundation

// Enum para as rotas da API da TMDb
public enum TMDbRouter {
    // Rotas de Filmes
    case nowPlayingMovies
    case popularMovies
    case topRatedMovies
    case upcomingMovies
    case movieDetails(id: Int)
    case movieImages(id: Int)
    
    // Rotas de Séries
    case popularTV
    case topRatedTV
    case tvDetails(id: Int)
    case tvSeasonDetails(tvId: Int, seasonNumber: Int)
    
    // Rotas de Atores
    case personDetails(id: Int)
    case personImages(id: Int)
}

// Classe de requisição, como você mencionou no seu código
public struct TMDbAPIRequest {
    public let router: TMDbRouter
    public let method: String
    public let params: [String: Any]?
    
    // URL Base da API da TMDb
    private static let baseURL = "https://api.themoviedb.org/3"
    
    public var url: URL? {
        var components = URLComponents(string: TMDbAPIRequest.baseURL)
        
        // Adiciona a rota ao caminho
        components?.path.append(router.path)
        
        // Adicione aqui a sua chave de API
        let apiKey = "SUA_API_KEY_AQUI"
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        // Adiciona parâmetros de consulta
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: "\($0.value)") })
        }
        
        components?.queryItems = queryItems
        
        return components?.url
    }
}

// Extensão para definir os caminhos da URL para cada rota
extension TMDbRouter {
    var path: String {
        switch self {
        case .nowPlayingMovies:
            return "/movie/now_playing"
        case .popularMovies:
            return "/movie/popular"
        case .topRatedMovies:
            return "/movie/top_rated"
        case .upcomingMovies:
            return "/movie/upcoming"
        case .movieDetails(let id):
            return "/movie/\(id)"
        case .movieImages(let id):
            return "/movie/\(id)/images"
        case .popularTV:
            return "/tv/popular"
        case .topRatedTV:
            return "/tv/top_rated"
        case .tvDetails(let id):
            return "/tv/\(id)"
        case .tvSeasonDetails(let tvId, let seasonNumber):
            return "/tv/\(tvId)/season/\(seasonNumber)"
        case .personDetails(let id):
            return "/person/\(id)"
        case .personImages(let id):
            return "/person/\(id)/images"
        }
    }
}
