//
//  MockAuthService.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//
import Foundation

class MockAuthService: AuthService {
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        // Simula uma chamada de rede
        DispatchQueue(label: "Mock").asyncAfter(deadline: .now() + 1.1) {
            if email == "teste@teste.com" && password == "123456" {
                let user = User(email: email)
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Credenciais inválidas."])))
            }
        }
    }
}

protocol AuthService {
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
}
