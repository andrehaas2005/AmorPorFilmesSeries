//
//  HomeViewControllerDelegate.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Features/Home/View/HomeViewController.swift
import UIKit

// Protocolo para o HomeViewController delegar ações ao seu coordenador.
protocol HomeViewControllerDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
    func didSelectSerie(_ serie: Serie)
    func didSelectActor(_ actor: Actor)
    func didRequestLogout() // Exemplo de ação que o HomeCoordinator pode precisar lidar
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    private let viewModel: HomeViewModel
    
    // UICollectionView para cada carrossel (simplificado para o exemplo)
    private let nowPlayingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 150, height: 200) // Tamanho estimado da célula
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()
    
    private let upcomingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 150, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()
    
    private let actorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 100, height: 150) // Células para atores (círculo)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ActorCell")
        return collectionView
    }()
    
    private let recentlyWatchedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 150, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()
    
    private let lastWatchedSeriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 150, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "SerieCell")
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
        view.backgroundColor = .white
        title = "Home"
        registerCollection()
        setupUI()
        setupBindings()
        viewModel.fetchHomeData() // Inicia a busca de dados
    }
    
    private func registerCollection() {
        nowPlayingCollectionView.dataSource = self
        nowPlayingCollectionView.delegate = self
        nowPlayingCollectionView.register(MovieCarouselCell.self, forCellWithReuseIdentifier: MovieCarouselCell.identifier)
        
        upcomingCollectionView.dataSource = self
        upcomingCollectionView.delegate = self
        upcomingCollectionView.register(MovieCarouselCell.self, forCellWithReuseIdentifier: MovieCarouselCell.identifier)
        
        actorsCollectionView.dataSource = self
        actorsCollectionView.delegate = self
        actorsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ActorCell")
        
        recentlyWatchedCollectionView.dataSource = self
        recentlyWatchedCollectionView.delegate = self
        recentlyWatchedCollectionView.register(MovieCarouselCell.self, forCellWithReuseIdentifier: MovieCarouselCell.identifier)
        
        lastWatchedSeriesCollectionView.dataSource = self
        lastWatchedSeriesCollectionView.delegate = self
        lastWatchedSeriesCollectionView.register(MovieCarouselCell.self, forCellWithReuseIdentifier: MovieCarouselCell.identifier)
        
    }
    
    private func setupUI() {
        // Exemplo de como adicionar as collection views (simplificado)
        let stackView = UIStackView(arrangedSubviews: [
            createSectionLabel("Filmes em Cartaz"), nowPlayingCollectionView,
            createSectionLabel("Filmes em Breve"), upcomingCollectionView,
            createSectionLabel("Atores Famosos"), actorsCollectionView,
            createSectionLabel("Assistidos Recentemente"), recentlyWatchedCollectionView,
            createSectionLabel("Últimos Episódios de Séries"), lastWatchedSeriesCollectionView
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            nowPlayingCollectionView.heightAnchor.constraint(equalToConstant: 220),
            upcomingCollectionView.heightAnchor.constraint(equalToConstant: 220),
            actorsCollectionView.heightAnchor.constraint(equalToConstant: 170),
            recentlyWatchedCollectionView.heightAnchor.constraint(equalToConstant: 220),
            lastWatchedSeriesCollectionView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func createSectionLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkText
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        return label
    }
    
    private func setupBindings() {
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self, let isLoading = isLoading else { return }
            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.errorMessage.bind { [weak self] message in
            guard let self = self, let message = message else { return }
            let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
        
        // Bindings para as coleções de dados
        viewModel.nowPlayingMovies.bind { [weak self] _ in
            self?.nowPlayingCollectionView.reloadData()
        }
        viewModel.upcomingMovies.bind { [weak self] _ in
            self?.upcomingCollectionView.reloadData()
        }
        viewModel.famousActors.bind { [weak self] _ in
            self?.actorsCollectionView.reloadData()
        }
        viewModel.recentlyWatchedMovies.bind { [weak self] _ in
            self?.recentlyWatchedCollectionView.reloadData()
        }
        viewModel.lastWatchedSeriesEpisodes.bind { [weak self] _ in
            self?.lastWatchedSeriesCollectionView.reloadData()
        }
    }
}
    // MARK: - UICollectionViewDataSource (Exemplo simplificado)
    // Em uma implementação real, teria um DataSource separado ou usaria DiffableDataSource.
    // Aqui, apenas para ilustrar a conexão.
    // Você precisaria de um delegate e datasource para cada collection view.

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == nowPlayingCollectionView {
            return viewModel.nowPlayingMovies.value??.count ?? 0
        } else if collectionView == upcomingCollectionView {
            return viewModel.upcomingMovies.value??.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Implementação da célula customizada para cada tipo de carrossel
        if collectionView == nowPlayingCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCarouselCell.identifier, for: indexPath) as? MovieCarouselCell else { return UICollectionViewCell() }
            if let movie = viewModel.nowPlayingMovies.value??[indexPath.item] {
                cell.configure(with: movie)
            }
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) // Placeholder
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Lógica para notificar o delegate sobre a seleção
        if collectionView == nowPlayingCollectionView, let movie = viewModel.nowPlayingMovies.value??[indexPath.item] {
            delegate?.didSelectMovie(movie)
        }
    }
}

