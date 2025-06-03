//
//  User.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


import Foundation

struct User: Codable {
    let id: String // Um ID único para o usuário
    let email: String
    var name: String?
    var nickname: String?
    var preferredGenres: [Genre] = []

    // Para simulação, podemos gerar um ID simples
    init(id: String = UUID().uuidString,
         email: String,
         name: String? = nil,
         nickname: String? = nil,
         preferredGenres: [Genre] = []) {
        self.id = id
        self.email = email
        self.name = name
        self.nickname = nickname
        self.preferredGenres = preferredGenres
    }
}
