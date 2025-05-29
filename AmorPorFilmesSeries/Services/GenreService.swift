// Services/GenreService.swift
import Foundation

// Implementação concreta do GenreServiceProtocol.
// Responsável por interagir com a API para buscar os gêneros.
class GenreService: GenreServiceProtocol {

    // Em um cenário real, você injetaria um `APIClient` aqui.
    // private let apiClient: APIClientProtocol

    // init(apiClient: APIClientProtocol) {
    //     self.apiClient = apiClient
    // }

    init() {
        // Para este exemplo, não precisamos de um apiClient real.
    }

    /// Simula a busca de gêneros de uma API.
    /// Em uma aplicação real, esta função faria uma requisição de rede.
    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        // Simula um atraso de rede.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Dados mockados que seriam retornados pela API.
            let mockGenres = [
                Genre(id: 1, name: "Ação"),
                Genre(id: 2, name: "Aventura"),
                Genre(id: 3, name: "Comédia"),
                Genre(id: 4, name: "Drama"),
                Genre(id: 5, name: "Ficção Científica"),
                Genre(id: 6, name: "Terror"),
                Genre(id: 7, name: "Romance"),
                Genre(id: 8, name: "Documentário"),
                Genre(id: 9, name: "Fantasia"),
                Genre(id: 10, name: "Animação")
            ]

            // Simula uma condição de erro (ex: 10% de chance de falha).
            let shouldFail = Bool.random() && false // Desabilitado para demonstração de sucesso
            if shouldFail {
                let error = NSError(domain: "GenreServiceError",
                                    code: 500,
                                    userInfo: [NSLocalizedDescriptionKey: "Falha ao buscar gêneros da API."])
                completion(.failure(error))
            } else {
                completion(.success(mockGenres))
            }
        }
    }
}
