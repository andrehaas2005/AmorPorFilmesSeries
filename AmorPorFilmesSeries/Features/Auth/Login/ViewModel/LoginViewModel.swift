//
//  LoginViewModel.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//
import Foundation

class LoginViewModel {
    // Usando Combine para simplificar o binding
    let errorMessage = Observable<String?>(nil)
    let isLoading = Observable<Bool>(false)
    let loginSuccess = Observable<Bool>(false)

    weak var coordinator: LoginCoordinator? // Para navegação
    private let authService: AuthService // Sua camada de serviço de autenticação

    init(authService: AuthService) {
        self.authService = authService
    }

    func login(email: String?, password: String?) {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty else {
            errorMessage.value = "Por favor, preencha todos os campos."
            return
        }

        isLoading.value = true
        // Simulação de chamada de serviço
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isLoading.value = false
            if email == "teste@teste.com" && password == "123456" {
                let user = User(email: email)
                self?.loginSuccess.value = true
                self?.coordinator?.didLogIn(user: user) // Notifica o Coordinator
            } else {
                self?.errorMessage.value = "Credenciais inválidas."
            }
        }

        // Em um cenário real, chamaria o serviço de autenticação aqui:
        // authService.login(email: email, password: password) { [weak self] result in
        //     DispatchQueue.main.async {
        //         self?.isLoading.value = false
        //         switch result {
        //         case .success(let user):
        //             self?.loginSuccess.value = true
        //             self?.coordinator?.didLogIn(user: user)
        //         case .failure(let error):
        //             self?.errorMessage.value = error.localizedDescription
        //         }
        //     }
        // }
    }

    func navigateToSignUp() {
        coordinator?.showSignUp()
    }
}
