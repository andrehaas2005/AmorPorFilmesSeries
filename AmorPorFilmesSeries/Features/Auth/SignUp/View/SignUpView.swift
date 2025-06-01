//
//  SignUpView.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


import UIKit

class SignUpView: UIView {

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Senha"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()

    let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirmar Senha"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nome"
        textField.borderStyle = .roundedRect
        return textField
    }()

    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Apelido"
        textField.borderStyle = .roundedRect
        return textField
    }()

    let genresLabel: UILabel = {
        let label = UILabel()
        label.text = "Gêneros Preferidos:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()

    let genresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize // Tamanho automático baseado no conteúdo
        layout.minimumInteritemSpacing = 8 // Espaçamento horizontal entre itens
        layout.minimumLineSpacing = 8 // Espaçamento vertical entre linhas
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cadastrar", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Já tenho conta? Entrar", for: .normal)
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
        setImageBackgroud(.sign)
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            confirmPasswordTextField,
            nameTextField,
            nicknameTextField,
            genresLabel,
            genresCollectionView,
            signUpButton,
            signInButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.distribution = .fill

        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor,
                                              constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 44),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 44),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            genresCollectionView.heightAnchor.constraint(equalToConstant: 40) // Altura fixa para a collection view
        ])
    }
}
