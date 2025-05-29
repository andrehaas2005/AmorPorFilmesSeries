//
//  Coordinator.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// App/Coordinator/AppCoordinator.swift
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: NavigationController { get set }

    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: NavigationController

    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // Verifica se o usuário já está logado (simulação)
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")

        if isLoggedIn {
            showHomeFlow()
        } else {
            showAuthFlow()
        }
    }

    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }

    private func showHomeFlow() {
        // Limpa a stack de navegação para a Home ser a raiz
        navigationController.viewControllers = []
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.delegate = self // Se a Home precisar delegar algo para o AppCoordinator
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func didLogIn(user: User) {
        // Salva o estado de login
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        // Inicia o fluxo da Home
        showHomeFlow()
    }

    func didCompleteAuthFlow() {
        // Este método será chamado quando o email for verificado ou o login for bem-sucedido
        // e o fluxo de autenticação for considerado completo.
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        showHomeFlow()
    }
}

extension AppCoordinator: HomeCoordinatorDelegate {
    // Se a Home precisar delegar alguma ação para o AppCoordinator (e.g., logout)
    func didRequestLogout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        childCoordinators.removeAll() // Remove todos os coordenadores filhos
        showAuthFlow() // Volta para o fluxo de autenticação
    }
}
