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


