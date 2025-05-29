//
//  GenreServiceProtocol.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Services/Protocols/GenreServiceProtocol.swift
import Foundation

// Define um protocolo para o serviço de gêneros.
// Isso permite a criação de mocks para testes e flexibilidade na implementação.
protocol GenreServiceProtocol {
    /// Busca uma lista de gêneros de filmes e séries da API.
    /// - Parameter completion: Um closure que será chamado com o resultado da operação.
    ///   - Success: Retorna um array de objetos `Genre`.
    ///   - Failure: Retorna um `Error` caso a requisição falhe.
    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void)
}
