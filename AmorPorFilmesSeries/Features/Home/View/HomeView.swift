//
//  HomeView.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 05/08/25.
//

import Kingfisher
import UIKit
import SnapKit

class HomeView: UIView {
    
    private let posterMovie: PosterCollectionView = {
        let poster = PosterCollectionView(service: NetworkAFMovieService.shared)
        return poster
    }()
    
    private let actorMovie: ActorsCollectionView = {
        let actor = ActorsCollectionView(service: MockActorService())
        return actor
    }()
    
    private let nowPlayingCollectionView: LancamentoViewController = {
        let vc = LancamentoViewController(service: NetworkAFMovieService.shared)
        return vc
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let nowPlayingLabel = createSectionLabel("Filmes em Cartaz")
    private let actorsLabel = createSectionLabel("Atores Populares")
    
    private func setupUI() {
        .addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        
        mainStackView.addArrangedSubview(posterMovie)
        mainStackView.addArrangedSubview(nowPlayingLabel)
        mainStackView.addArrangedSubview(nowPlayingCollectionView)
        mainStackView.addArrangedSubview(actorsLabel)
        mainStackView.addArrangedSubview(actorMovie)
        
        // Constraints para o UIScrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: superview?.safeAreaLayoutGuide.topAnchor),
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
    }
}

extension HomeView {
    
    private static func createSectionLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkText
        label.textAlignment = .center
        return label
    }
}
