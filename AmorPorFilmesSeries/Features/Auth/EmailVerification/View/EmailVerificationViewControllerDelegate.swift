//
//  EmailVerificationViewControllerDelegate.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Features/Auth/EmailVerification/View/EmailVerificationViewController.swift
import UIKit

protocol EmailVerificationViewControllerDelegate: AnyObject {
    func didVerifyEmailSuccessfully()
}

class EmailVerificationViewController: UIViewController {

    weak var delegate: EmailVerificationViewControllerDelegate?
    private let viewModel: EmailVerificationViewModel
    private let emailVerificationView = EmailVerificationView()

    init(viewModel: EmailVerificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = emailVerificationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Verificar Email"
        emailVerificationView.emailLabel.text = "Um token de confirmação foi enviado para \(viewModel.email)."
        setupBindings()
        emailVerificationView.verifyButton.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.errorMessage.bind { [weak self] message in
            guard let self = self,
                  let message = message else { return }
            let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }

        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading else { return }
            self.emailVerificationView.verifyButton.setTitle(isLoading ? "Verificando..." : "Verificar", for: .normal)
            self.emailVerificationView.verifyButton.isEnabled = !isLoading
        }

        viewModel.verificationSuccess.bind { [weak self] success in
            guard let self = self,
                  success != nil else { return }
            self.delegate?.didVerifyEmailSuccessfully()
        }
    }

    @objc private func verifyButtonTapped() {
        viewModel.verifyEmail(token: emailVerificationView.tokenTextField.text)
    }
}
