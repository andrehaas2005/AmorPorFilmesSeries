//
//  EmailVerificationView.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Features/Auth/EmailVerification/View/EmailVerificationView.swift
import UIKit

class EmailVerificationView: UIView {

    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    let tokenTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Código de Verificação"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()

    let verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Verificar", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [
            emailLabel,
            tokenTextField,
            verifyButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            tokenTextField.heightAnchor.constraint(equalToConstant: 44),
            verifyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
