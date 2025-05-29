//
//  EmailVerificationViewModel.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


import Foundation

class EmailVerificationViewModel {
    let email: String
    let errorMessage = Observable<String?>(nil)
    let isLoading = Observable<Bool>(false)
    let verificationSuccess = Observable<Bool>(false)

    weak var coordinator: EmailVerificationCoordinator?
    private let userService: UserService

    init(email: String, userService: UserService) {
        self.email = email
        self.userService = userService
    }

    func verifyEmail(token: String?) {
        guard let token = token, !token.isEmpty else {
            errorMessage.value = "Por favor, insira o código de verificação."
            return
        }

        isLoading.value = true
        userService.verifyEmail(email: email, token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading.value = false
                switch result {
                case .success(let isVerified):
                    if isVerified {
                        self?.verificationSuccess.value = true
                        self?.coordinator?.didVerifyEmail()
                    } else {
                        self?.errorMessage.value = "Token inválido."
                    }
                case .failure(let error):
                    self?.errorMessage.value = error.localizedDescription
                }
            }
        }
    }
}
