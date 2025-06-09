//
//  PosterCollection.swift
//  AmorPorFilmesSeries
//
//  Created by Andre Haas on 04/06/25.
//

import UIKit
import SnapKit
import ModuloServiceMovie

class PosterCollectionView: UIView {
    
    let service: MovieServiceProtocol?
    var viewModel: PosterViewModel?
    
    let posterCollection: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Usaremos apenas um inicializador principal, injetando o serviço
    init(service: MovieServiceProtocol = MovieListService()) {
        self.service = service
        super.init(frame: .zero) // Inicializa com frame zero, as constraints definirão o tamanho real
        insertService()
        setupCollectionView()
        setupBindings()
        // Adicionar o `fetchPosterData()` aqui para iniciar a busca de dados assim que a view for criada.
        viewModel?.fetchData()
    }
    
    private func insertService() {
        self.viewModel = PosterViewModel(movieService: self.service ?? MovieListService())
        posterCollection.dataSource = self
        posterCollection.delegate = self // O delegate deve ser a própria PosterCollection
    }
    
    func setupCollectionView() {
        posterCollection.register(PosterGrandeCell.self,
                                  forCellWithReuseIdentifier: PosterGrandeCell.identifier)
        
        addSubview(posterCollection)
        posterCollection.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel?.items.bind { [weak self] _ in
            DispatchQueue.main.async { // Garante que o reloadData ocorra na thread principal
                self?.posterCollection.reloadData()
            }
        }
    }
}

extension PosterCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel?.items.value?.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterGrandeCell.identifier,
                                                            for: indexPath) as? PosterGrandeCell else {
            return UICollectionViewCell()
        }
        
        if let movie = viewModel?.items.value?[indexPath.row] {
            cell.cellBuilder(poster: movie.posterPath, name: movie.title)
        }
        return cell
    }
}

// Implementar UICollectionViewDelegateFlowLayout para definir o tamanho da célula
extension PosterCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width // Largura total da CollectionView
        let height = collectionView.bounds.height // Altura total da CollectionView
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// Adicione aqui a extensão para o scroll view se desejar o efeito de snap para o poster
extension PosterCollectionView: UICollectionViewDelegate {
    // Para um efeito de "paging" ou "snap" para cada poster.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = posterCollection.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee.x
        let index = (offset + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left
        targetContentOffset.pointee = CGPoint(x: offset, y: scrollView.contentOffset.y)
    }
}
