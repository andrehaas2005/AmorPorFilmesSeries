//
//  EmailVerificationCoordinator.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


import UIKit

class EmailVerificationCoordinator: Coordinator, EmailVerificationViewControllerDelegate {

    weak var parentCoordinator: AuthCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: NavigationController
    private let email: String

    init(navigationController: NavigationController, email: String) {
        self.navigationController = navigationController
        self.email = email
    }

    func start() {
        let viewModel = EmailVerificationViewModel(email: email,
                                                   userService: MockUserService()) // Usar o serviço real aqui
        viewModel.coordinator = self
        let viewController = EmailVerificationViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

    func didVerifyEmail() {
        // Após a verificação, o fluxo de autenticação é considerado completo
        parentCoordinator?.didCompleteEmailVerification()
    }
    
    func didVerifyEmailSuccessfully() {
        
    }
}

extension EmailVerificationViewController: EmailVerificationViewControllerDelegate {
    func didVerifyEmailSuccessfully() {
        (navigationController?.coordinator as? EmailVerificationCoordinator)?.didVerifyEmail()
    }
}
