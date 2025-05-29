//
//  MovieServiceProtocol.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Services/Protocols/MovieServiceProtocol.swift
import Foundation

// Define o protocolo para o serviço de filmes.
public protocol MovieServiceProtocol {
    /// Busca filmes que estão atualmente em cartaz.
    func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], Error>) -> Void)

    /// Busca filmes que serão lançados em breve.
    func fetchUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void)

    /// Busca filmes assistidos recentemente pelo usuário.
    func fetchRecentlyWatchedMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
    
    
}
