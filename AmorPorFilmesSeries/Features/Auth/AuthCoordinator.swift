//
//  AuthCoordinatorDelegate.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Features/Auth/Coordinator/AuthCoordinator.swift (Atualizado)
import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
    func didLogIn(user: User)
    func didCompleteAuthFlow() // Novo método para quando o fluxo de autenticação é concluído
}

class AuthCoordinator: Coordinator {
    weak var delegate: AuthCoordinatorDelegate?
    var childCoordinators: [Coordinator] = []
    var navigationController: NavigationController

    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showLogin() // Inicia sempre pela tela de Login
    }

    func showLogin() {
        // Remove outros child coordinators para garantir que apenas um fluxo de auth esteja ativo
        childCoordinators.removeAll()
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.parentCoordinator = self
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }

    func showSignUp() {
        // Remove outros child coordinators para garantir que apenas um fluxo de auth esteja ativo
        childCoordinators.removeAll()
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        signUpCoordinator.parentCoordinator = self
        childCoordinators.append(signUpCoordinator)
        signUpCoordinator.start()
    }

    func didLogIn(user: User) {
        delegate?.didLogIn(user: user)
        delegate?.didCompleteAuthFlow() // Notifica o AppCoordinator que o fluxo de auth foi concluído
    }

    func didCompleteEmailVerification() {
        // Após a verificação de email, o fluxo de autenticação foi concluído com sucesso
        delegate?.didCompleteAuthFlow()
    }
}
