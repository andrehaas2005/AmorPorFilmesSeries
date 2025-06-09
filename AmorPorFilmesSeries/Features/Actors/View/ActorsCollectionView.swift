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
    
    let actorsCollection: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewLayout)
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
        self.viewModel = ActorsViewModel(actorService: service)
        actorsCollection.dataSource = self
        actorsCollection.delegate = self
        actorsCollection.register(ActorsCell.self, forCellWithReuseIdentifier: ActorsCell.identifier)
    }
    private func setupBindings() {
        viewModel?.items.bind { [weak self] _ in
            DispatchQueue.main.async { // Garante que o reloadData ocorra na thread principal
                self?.actorsCollection.reloadData()
            }
        }
    }
    
    func setupUI() {
        addSubview(actorsCollection)
        actorsCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
        guard let item = viewModel?.items.value?[indexPath.row] else { return UICollectionViewCell() }
        
        cell.cellBuilder(items: (poster: item.profilePath, name: item.name, fantasiaNameText: ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel?.items.value?.count ?? 0
    }
}

extension ActorsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}
