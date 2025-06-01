//
//  SignUpViewControllerDelegate.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Features/Auth/SignUp/View/SignUpViewController.swift
import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
    func didTapSignIn()
    func didSignUpSuccessfully(email: String)
}

class SignUpViewController: UIViewController {

    weak var delegate: SignUpViewControllerDelegate?
    private let viewModel: SignUpViewModel
    private let signUpView = SignUpView()

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cadastro"
        setupBindings()
        setupTargets()

        signUpView.genresCollectionView.delegate = self
        signUpView.genresCollectionView.dataSource = self
        signUpView.genresCollectionView.register(GenreSelectionCell.self, forCellWithReuseIdentifier: GenreSelectionCell.reuseIdentifier)

        viewModel.fetchGenres() // Carrega os gêneros ao iniciar a tela
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
            self.signUpView.signUpButton.setTitle(isLoading ? "Cadastrando..." : "Cadastrar", for: .normal)
            self.signUpView.signUpButton.isEnabled = !isLoading
        }

        viewModel.genres.bind { [weak self] _ in
            self?.signUpView.genresCollectionView.reloadData()
        }

        viewModel.signUpSuccess.bind { [weak self] success in
            guard let self = self,
                  success != nil else { return }
            if let email = self.signUpView.emailTextField.text {
                self.delegate?.didSignUpSuccessfully(email: email)
            }
        }
    }

    private func setupTargets() {
        signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signUpView.signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }

    @objc private func signUpButtonTapped() {
        viewModel.signUp(
            email: signUpView.emailTextField.text,
            password: signUpView.passwordTextField.text,
            passwordConfirmation: signUpView.confirmPasswordTextField.text,
            name: signUpView.nameTextField.text,
            nickname: signUpView.nicknameTextField.text
        )
    }

    @objc private func signInButtonTapped() {
        delegate?.didTapSignIn()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SignUpViewController: UICollectionViewDelegate, UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.genres.value??.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreSelectionCell.reuseIdentifier,
                                                            for: indexPath) as? GenreSelectionCell else {
            return UICollectionViewCell()
        }
        if let genre = viewModel.genres.value??[indexPath.item] {
            cell.configure(with: genre.name, isSelected: viewModel.selectedGenres.value??.contains(genre) ?? false)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let genre = viewModel.genres.value??[indexPath.item] {
            viewModel.toggleGenreSelection(genre)
            collectionView.reloadItems(at: [indexPath])
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calcular o tamanho da célula com base no texto do gênero
        guard let genreName = viewModel.genres.value??[indexPath.item].name else { return .zero }
        let font = UIFont.systemFont(ofSize: 14)
        let textWidth = genreName.size(withAttributes: [.font: font]).width
        let padding: CGFloat = 20 // Padding interno da célula
        return CGSize(width: textWidth + padding, height: 30) // Altura fixa
    }
}
