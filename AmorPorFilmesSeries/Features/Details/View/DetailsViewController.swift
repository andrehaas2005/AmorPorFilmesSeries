//
//  DetailsViewController.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Features/Details/View/DetailsViewController.swift
import UIKit

class DetailsViewController: UIViewController {

    private let viewModel: DetailsViewModel

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 300), // Altura fixa para a imagem
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7) // Largura da imagem
        ])
    }

    private func setupBindings() {
        viewModel.title.bind { [weak self] text in
            guard let self = self else { return }
            self.titleLabel.text = text ?? String()
        }
        viewModel.description.bind { [weak self] text in
            guard let self = self else { return }
            self.descriptionLabel.text = text ?? String()
        }
        viewModel.imageUrl.bind { [weak self] url in
            //Haas
            // Em uma aplicação real, você usaria uma biblioteca como Kingfisher para carregar a imagem.
            // Exemplo de carregamento simples (não recomendado para produção):
            if let url = url, url != nil {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url!) {
                        DispatchQueue.main.async {
                            self?.imageView.image = UIImage(data: data)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.imageView.image = nil // Ou uma imagem placeholder
                }
            }
        }
    }
}
