
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



