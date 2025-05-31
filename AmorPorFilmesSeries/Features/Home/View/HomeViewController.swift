//
//  HomeViewController.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre Haas on 28/05/25.
//

import UIKit
import SnapKit
import Kingfisher

protocol HomeViewControllerDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
    func didSelectSerie(_ serie: Serie)
    func didSelectActor(_ actor: Actor)
    func didRequestLogout()
}

enum Section {
    case main
    case second
}

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    weak var delegate: HomeViewControllerDelegate?
    private let viewModel: HomeViewModel

    private let nowPlayingLabel = createSectionLabel("Filmes em Cartaz")
    private let nowPlayingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 150, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let upcomingLabel = createSectionLabel("Filmes em Breve")
    private let upcomingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 150, height: 200)
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
        view.backgroundColor = .white
        title = "Home"
        registerCollection()
        setupLogoutButton()
        setupUI()
        setupBindings()
        viewModel.fetchHomeData()
    }
    
    func setupLogoutButton() {
        // Tente usar um símbolo do sistema primeiro (iOS 13+)
        if #available(iOS 13.0, *) {
            let logoutImage = UIImage(systemName: "rectangle.portrait.and.arrow.right")
            let logoutBarButtonItem = UIBarButtonItem(image: logoutImage, style: .plain, target: self, action: #selector(logoutTapped))
            navigationItem.rightBarButtonItem = logoutBarButtonItem
        } else {
            // Se estiver rodando em versões anteriores do iOS, você precisará usar uma imagem do seu Assets.xcassets
            if let logoutImage = UIImage(named: "logout_icon") { // Substitua "logout_icon" pelo nome da sua imagem
                let logoutBarButtonItem = UIBarButtonItem(image: logoutImage, style: .plain, target: self, action: #selector(logoutTapped))
                navigationItem.rightBarButtonItem = logoutBarButtonItem
            } else {
                // Fallback se a imagem não for encontrada
                let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
                navigationItem.rightBarButtonItem = logoutBarButtonItem
            }
        }
    }

    @objc func logoutTapped() {
        delegate?.didRequestLogout()
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

        viewModel.nowPlayingMovies.bind { [weak self] movies in
            self?.nowPlayingCollectionView.reloadData()
        }

        viewModel.upcomingMovies.bind { [weak self] movies in
            self?.upcomingCollectionView.reloadData()
        }
    }

    private func registerCollection() {
        nowPlayingCollectionView.delegate = self
        nowPlayingCollectionView.dataSource = self
        nowPlayingCollectionView.register(MovieCarouselCell.self, forCellWithReuseIdentifier: MovieCarouselCell.identifier)

        upcomingCollectionView.delegate = self
        upcomingCollectionView.dataSource = self
        upcomingCollectionView.register(MovieCarouselCell.self, forCellWithReuseIdentifier: MovieCarouselCell.identifier)
    }

    private func setupUI() {
        view.addSubview(nowPlayingLabel)
        view.addSubview(nowPlayingCollectionView)
        view.addSubview(upcomingLabel)
        view.addSubview(upcomingCollectionView)
        view.addSubview(activityIndicator)

        nowPlayingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }

        nowPlayingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nowPlayingLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(220).priority(.high)
        }

        upcomingLabel.snp.makeConstraints { make in
            make.top.equalTo(nowPlayingCollectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }

        upcomingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(upcomingLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(220).priority(.high)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    private static func createSectionLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkText
        label.textAlignment = .center
        return label
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == nowPlayingCollectionView {
            return viewModel.nowPlayingMovies.value??.count ?? 0
        } else if collectionView == upcomingCollectionView {
            return viewModel.upcomingMovies.value??.count ?? 0
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == nowPlayingCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCarouselCell.identifier, for: indexPath) as? MovieCarouselCell else {
                fatalError("Could not dequeue MovieCarouselCell")
            }
            if let movie = viewModel.nowPlayingMovies.value??[indexPath.item] {
                cell.configure(with: movie)
            }
            return cell
        } else if collectionView == upcomingCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCarouselCell.identifier, for: indexPath) as? MovieCarouselCell else {
                fatalError("Could not dequeue MovieCarouselCell")
            }
            if let movie = viewModel.upcomingMovies.value??[indexPath.item] {
                cell.configure(with: movie)
            }
            return cell
        }
        return UICollectionViewCell()
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == upcomingCollectionView || collectionView == nowPlayingCollectionView {
            return CGSize(width: 150, height: 200)
        }
        return (collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize ?? CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == nowPlayingCollectionView, let movie = viewModel.nowPlayingMovies.value??[indexPath.item] {
            delegate?.didSelectMovie(movie)
        } else if collectionView == upcomingCollectionView, let movie = viewModel.upcomingMovies.value??[indexPath.item] {
            delegate?.didSelectMovie(movie)
        }
    }
}
