//
//  UserService.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


import Foundation

protocol UserService {
    func registerUser(user: User, passwordConfirmation: String, completion: @escaping (Result<User, Error>) -> Void)
    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void)
    func verifyEmail(email: String, token: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class MockUserService: UserService {
    func registerUser(user: User, passwordConfirmation: String, completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Simulação de validação e registro
            if user.email.isEmpty || user.name?.isEmpty ?? true || user.nickname?.isEmpty ?? true || passwordConfirmation.isEmpty {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Todos os campos são obrigatórios."])))
                return
            }
            if user.email.contains("error") { // Simular erro de email
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Email já cadastrado ou inválido."])))
                return
            }
            // Simula o sucesso do registro e o envio do token
            print("Usuário \(user.email) registrado. Token de confirmação enviado para o email.")
            completion(.success(user))
        }
    }

    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
            completion(.success(mockGenres))
        }
    }

    func verifyEmail(email: String, token: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if token == "123456" { // Token de simulação
                completion(.success(true))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Token inválido."])))
            }
        }
    }
}
