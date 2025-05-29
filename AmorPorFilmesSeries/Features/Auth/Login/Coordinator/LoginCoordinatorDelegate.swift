//
//  LoginCoordinatorDelegate.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


protocol LoginCoordinatorDelegate: AnyObject {
    func didLogIn(user: User)
    func showSignUp()
}