//
//  MovieCarouselCell.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 29/05/25.
//


// MovieCarouselCell.swift
import Kingfisher
import UIKit
import SnapKit

class MovieCarouselCell: UICollectionViewCell {
    
    static let identifier = "MovieCell"
    
    private let cellBox: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 220))
        view.backgroundColor = .black
        return view
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        cellBox.addSubview(movieImageView)
        cellBox.addSubview(titleLabel)
//        
//        cellBox.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(8)
//            make.top.bottom.equalToSuperview().inset(8)
//        }
        
        movieImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(8)
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
            make.top.equalTo(movieImageView.snp.bottom).offset(8)
        }
        
        // Adiciona um gradiente para melhorar a legibilidade do título
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.blue.withAlphaComponent(0.5).cgColor]
        gradientLayer.locations = [0.5, 1.0]
        cellBox.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = bounds
        gradientLayer.masksToBounds = true
        contentView.addSubview(cellBox)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.kf.cancelDownloadTask()
        movieImageView.image = nil
        titleLabel.text = nil
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
        if !movie.posterPath.isEmpty {
            let imageURL = URL(string: Configuration.imageBaseURL + movie.posterPath)
            movieImageView.kf.setImage(with: imageURL)
        } else {
            
            movieImageView.image = UIImage(named: "movie-placeholder")
        }
    }
}
