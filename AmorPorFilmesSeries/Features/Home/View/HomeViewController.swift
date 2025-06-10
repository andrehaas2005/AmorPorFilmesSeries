//
//  HomeViewController.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre Haas on 28/05/25.
//

import Kingfisher
import UIKit
import SnapKit

protocol HomeViewControllerDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
    //    func didSelectSerie(_ serie: Serie)
    //    func didSelectActor(_ actor: Actor)
    func didRequestLogout()
}

enum Section {
    case main
    case second
}

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    weak var delegate: HomeViewControllerDelegate?
    private let viewModel: HomeViewModel
    
    
    private let posterMovie: PosterCollectionView = {
        let poster = PosterCollectionView(service: MockMovieService())
        return poster
    }()
    
    private let actorMovie: ActorsCollectionView = {
        let actor = ActorsCollectionView(service: MockActorService())
        return actor
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let nowPlayingLabel = createSectionLabel("Filmes em Cartaz")
    private let actorsLabel = createSectionLabel("Atores Populares")
    
    private let nowPlayingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //        layout.estimatedItemSize = CGSize(width: 150, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.primaryLight
        title = "Próximos Lançamentos"
        registerCollection()
        setupLogoutButton()
        setupUI() // Chama setupUI que adiciona posterMovie
        setupBindings()
        viewModel.fetchData() // Inicia a busca de dados para os outros carrosséis
        // O PosterViewModel (dentro de PosterCollection) já chama seu próprio fetchPosterData()
    }
    
    func setupLogoutButton() {
        if #available(iOS 13.0, *) {
            let logoutImage = UIImage(systemName: "rectangle.portrait.and.arrow.right")
            let logoutBarButtonItem = UIBarButtonItem(image: logoutImage, style: .plain,
                                                      target: self, action: #selector(logoutTapped))
            navigationItem.rightBarButtonItem = logoutBarButtonItem
        } else {
            if let logoutImage = UIImage(named: "logout_icon") {
                let logoutBarButtonItem = UIBarButtonItem(image: logoutImage, style: .plain,
                                                          target: self, action: #selector(logoutTapped))
                navigationItem.rightBarButtonItem = logoutBarButtonItem
            } else {
                let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain,
                                                          target: self, action: #selector(logoutTapped))
                navigationItem.rightBarButtonItem = logoutBarButtonItem
            }
        }
    }
    
    @objc func logoutTapped() {
        delegate?.didRequestLogout()
    }
    
    private func setupBindings() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading else { return }
            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.errorMessage.bind { [weak self] message in
            guard let self = self,
                  let message = message else { return }
            let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
        
        viewModel.items.bind { [weak self] _ in
            self?.nowPlayingCollectionView.reloadData()
        }
    }
    
    private func registerCollection() {
        nowPlayingCollectionView.delegate = self
        nowPlayingCollectionView.dataSource = self
        nowPlayingCollectionView.register(MovieCarouselCell.self,
                                          forCellWithReuseIdentifier: MovieCarouselCell.identifier)
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
    
        mainStackView.addArrangedSubview(posterMovie)
        mainStackView.addArrangedSubview(nowPlayingLabel)
        mainStackView.addArrangedSubview(nowPlayingCollectionView)
        mainStackView.addArrangedSubview(actorsLabel)
        mainStackView.addArrangedSubview(actorMovie)
        
        // Constraints para o UIScrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Constraints para o UIStackView dentro do UIScrollView
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        posterMovie.snp.makeConstraints { make in
            make.height.equalTo(350) // Altura do banner principal
            make.leading.trailing.equalToSuperview()
        }
        
        actorMovie.snp.makeConstraints { make in
            make.height.equalTo(150) // Altura do banner principal
            make.leading.trailing.equalToSuperview()
        }
        
        nowPlayingCollectionView.snp.makeConstraints { make in
            make.height.equalTo(220)
            make.leading.trailing.equalToSuperview()
        }
        
        // Adiciona e configura o activityIndicator
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private static func createSectionLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkText
        label.textAlignment = .center
        return label
    }
    
    // MARK: - UICollectionViewDataSource (para nowPlayingCollectionView)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCarouselCell.identifier,
                                                            for: indexPath) as? MovieCarouselCell else {
            return UICollectionViewCell()
        }
        if let movie = viewModel.items.value?[indexPath.item] {
            cell.configure(with: movie)
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout (para nowPlayingCollectionView)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == nowPlayingCollectionView {
            return CGSize(width: 150, height: 220)
        }
        return .zero // Retorno padrão para outras coleções
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = viewModel.items.value?[indexPath.item] {
            delegate?.didSelectMovie(movie)
        }
    }
}
