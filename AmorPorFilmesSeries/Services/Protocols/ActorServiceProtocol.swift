//
//  ActorServiceProtocol.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Services/Protocols/ActorServiceProtocol.swift
import Foundation

// Define o protocolo para o serviço de atores.
protocol ActorServiceProtocol {
    /// Busca uma lista de atores famosos.
    func fetchFamousActors(completion: @escaping (Result<[Actor], Error>) -> Void)
}
//https://api.themoviedb.org/3/person/popular
