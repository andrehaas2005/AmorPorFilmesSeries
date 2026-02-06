//
//  LancamentoViewController.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 21/06/25.
//

import UIKit
import SnapKit

protocol LancamentoViewControllerDelegate {
    func updateMovie(_ movies: [Movie])
}

class LancamentoViewController: UIView {
    private let service: MovieServiceProtocol
    private var viewModel: (any MovieViewModelProtocol)?
    weak var delegate: HomeViewControllerDelegate?
    
    
    private let nowPlayingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //        layout.estimatedItemSize = CGSize(width: 150, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
        super.init(frame: .zero)
        insertService()
        setupCollectionView()
        setupBindings()
//        viewModel?.fetchData()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func insertService() {
        self.viewModel = LancamentoViewModel(movieService: self.service)
        nowPlayingCollectionView.dataSource = self
        nowPlayingCollectionView.delegate = self // O delegate deve ser a própria PosterCollection
    }
    
    func setupCollectionView() {
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        nowPlayingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        nowPlayingCollectionView.register(MovieCarouselCell.self,
                                          forCellWithReuseIdentifier: MovieCarouselCell.identifier)
        
        addSubview(nowPlayingCollectionView)
        addSubview(activityIndicator)
        nowPlayingCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setupBindings() {
        
        viewModel?.isLoading.bind { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading else { return }
            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
        
        viewModel?.errorMessage.bind { [weak self] message in
            guard let message = message else { return }
            let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            //            self.present(alert, animated: true)
        }
        viewModel?.items.bind { [weak self] _ in
            DispatchQueue.main.async { // Garante que o reloadData ocorra na thread principal
                self?.nowPlayingCollectionView.reloadData()
            }
        }
    }
}

extension LancamentoViewController: LancamentoViewControllerDelegate {
    func updateMovie(_ movies: [Movie]) {
        viewModel?.items.value = movies
    }
}

extension LancamentoViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.items.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCarouselCell.identifier,
                                                            for: indexPath) as? MovieCarouselCell else {
            return UICollectionViewCell()
        }
        if let movie = viewModel?.items.value?[indexPath.item] {
            cell.configure(with: movie)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = viewModel?.items.value?[indexPath.item] {
            delegate?.didSelectMovie(movie)
        }
    }
}
