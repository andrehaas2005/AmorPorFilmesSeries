//
//  ActorsView.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 09/06/25.
//
import UIKit
import SnapKit

class ActorsCollectionView: UIView {
    
    let service: ActorServiceProtocol?
    var viewModel: ActorsViewModel?
    
    private let actorsCollection: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewLayout)
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(service: ActorServiceProtocol) {
        self.service = service
        super.init(frame: .zero)
        setupCollection()
        setupUI()
        setupBindings()
        viewModel?.fetchData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollection() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        viewModel = ActorsViewModel(actorService: service ?? MockActorService())
        actorsCollection.dataSource = self
        actorsCollection.delegate = self
        actorsCollection.register(ActorsCell.self, forCellWithReuseIdentifier: ActorsCell.identifier)
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
        viewModel?.items.bind { [weak self] _ in
            DispatchQueue.main.async { // Garante que o reloadData ocorra na thread principal
                self?.actorsCollection.reloadData()
            }
        }
    }
    
    func setupUI() {
        addSubview(actorsCollection)
        addSubview(activityIndicator)
        actorsCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

extension ActorsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorsCell.identifier,
                                                            for: indexPath) as? ActorsCell
        else {
            return UICollectionViewCell()
        }
        guard let item = viewModel?.actors.value?[indexPath.row] else { return UICollectionViewCell() }
        
        cell.cellBuilder(items: (poster: item.profilePath, name: item.name, fantasiaNameText: ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel?.actors.value?.count ?? 0
    }
}

extension ActorsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}
