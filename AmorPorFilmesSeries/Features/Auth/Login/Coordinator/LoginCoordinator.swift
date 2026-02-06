//
//  LoginCoordinatorDelegate.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//

class LoginCoordinator: CoordinatorProtocol {
    weak var parentCoordinator: AuthCoordinator?
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: NavigationController

    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = LoginViewModel(authService: MockAuthService()) // Usar o serviço real aqui
        viewModel.coordinator = self
        let viewController = LoginViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }

    func didLogIn(user: User) {
        parentCoordinator?.didLogIn(user: user)
    }

    func showSignUp() {
        parentCoordinator?.showSignUp()
    }
}
