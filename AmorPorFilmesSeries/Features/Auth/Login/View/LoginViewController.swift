//
//  LoginViewControllerDelegate.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func didTapSignUp()
    func didLogIn()
}

class LoginViewController: UIViewController {

    weak var delegate: LoginViewControllerDelegate?
    private let viewModel: LoginViewModel
    private let loginView = LoginView() // Uma UIView customizada para os elementos da tela

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        setupBindings()
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.errorMessage.bind { [weak self] message in
            guard let self = self,
                  let message = message else { return }
            
            // Mostrar mensagem de erro na UI
            let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }

        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading else { return }
            // Mostrar/esconder indicador de loading
            self.loginView.loginButton.setTitle(isLoading ? "Entrando..." : "Entrar", for: .normal)
            self.loginView.loginButton.isEnabled = !isLoading
        }

        viewModel.loginSuccess.bind { [weak self] success in
            guard let self = self,
                  let _ = success else { return }
            self.delegate?.didLogIn()
        }
    }

    @objc private func loginButtonTapped() {
        viewModel.login(email: loginView.emailTextField.text, password: loginView.passwordTextField.text)
    }

    @objc private func signUpButtonTapped() {
        viewModel.navigateToSignUp()
    }
}

extension LoginViewController: LoginViewControllerDelegate {
    func didTapSignUp() {
        (navigationController?.coordinator as? LoginCoordinator)?.showSignUp()
    }

    func didLogIn() {
        (navigationController?.coordinator as? LoginCoordinator)?.didLogIn(user: User(email: "teste@teste.com")) // Simulação de usuário
    }
}
