//
//  SignUpCoordinator.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//

// Features/Auth/SignUp/Coordinator/SignUpCoordinator.swift
import UIKit

//class SignUpCoordinator: Coordinator, SignUpViewControllerDelegate {
//    func didTapSignIn() {
//        //Haas
//    }
//    
//    func didSignUpSuccessfully(email: String) {
//        //Haas
//    }
//    
//    weak var parentCoordinator: AuthCoordinator?
//    var childCoordinators: [Coordinator] = []
//    var navigationController: UINavigationController
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//
//    func start() {
//        let viewModel = SignUpViewModel(userService: MockUserService()) // Usar o serviço real aqui
//        viewModel.coordinator = self
//        let viewController = SignUpViewController(viewModel: viewModel)
//        viewController.delegate = self
//        navigationController.pushViewController(viewController, animated: true)
//    }
//
//    func didSignUp(email: String) {
//        // Após o cadastro, navega para a tela de verificação de email
//        let emailVerificationCoordinator = EmailVerificationCoordinator(navigationController: navigationController as! NavigationController, email: email)
//        emailVerificationCoordinator.parentCoordinator = parentCoordinator // O parent do EmailVerification é o AuthCoordinator
//        childCoordinators.append(emailVerificationCoordinator)
//        emailVerificationCoordinator.start()
//    }
//
//    func showSignIn() {
//        // Retorna para a tela de Login
//        parentCoordinator?.showLogin() // Assumindo que AuthCoordinator tem um método para mostrar Login
//    }
//}
//
//extension SignUpViewController: SignUpViewControllerDelegate {
//    func didTapSignIn() {
//        (navigationController?.coordinator as? SignUpCoordinator)?.showSignIn()
//    }
//
//    func didSignUpSuccessfully(email: String) {
//        (navigationController?.coordinator as? SignUpCoordinator)?.didSignUp(email: email)
//    }
//}



//=============================================
//// Features/Auth/SignUp/Coordinator/SignUpCoordinator.swift (Atualizado)
//import UIKit
//
//// Define um protocolo básico para Coordenadores.
//protocol Coordinator: AnyObject {
//    var childCoordinators: [Coordinator] { get set }
//    var navigationController: UINavigationController { get set }
//    func start()
//}
//
import Foundation

class SignUpCoordinator: Coordinator {
    
    weak var parentCoordinator: AuthCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: NavigationController

    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // Instancia os serviços reais (ou mocks para testes).
        let userService = MockUserService() // Use seu UserService real aqui
        let genreService = GenreService() // NOVO: Instancia o GenreService real aqui

        // Injeta os serviços no ViewModel.
        let viewModel = SignUpViewModel(userService: userService, genreService: genreService)
        viewModel.coordinator = self
        let viewController = SignUpViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }

    /// Chamado pelo ViewModel quando o cadastro é bem-sucedido.
    /// Inicia o fluxo de verificação de email.
    func didSignUp(email: String) {
        let emailVerificationCoordinator = EmailVerificationCoordinator(navigationController: navigationController, email: email)
        emailVerificationCoordinator.parentCoordinator = parentCoordinator
        childCoordinators.append(emailVerificationCoordinator)
        emailVerificationCoordinator.start()
    }

    /// Chamado pelo ViewModel para retornar à tela de login.
    func showSignIn() {
        parentCoordinator?.showLogin() // Assumindo que AuthCoordinator tem um método para mostrar Login
    }
}

// Extensão para conformar SignUpViewController ao seu delegate.
extension SignUpCoordinator: SignUpViewControllerDelegate {
    func didTapSignIn() {
        // Opcional: Acesso ao coordenador através da navigationController para maior clareza.
        (navigationController.coordinator as? SignUpCoordinator)?.showSignIn()
    }

    func didSignUpSuccessfully(email: String) {
        (navigationController.coordinator as? SignUpCoordinator)?.didSignUp(email: email)
    }
}



