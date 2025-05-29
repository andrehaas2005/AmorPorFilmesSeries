//
//  LoginViewModelDelegate.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


protocol LoginViewModelDelegate: AnyObject {
    func didLogInSuccessfully(user: User)
    func didFailToLogIn(error: Error)
}
