//
//  MovieCarouselCell.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 29/05/25.
//


// MovieCarouselCell.swift
import UIKit
import Kingfisher
import SnapKit

class MovieCarouselCell: UICollectionViewCell {
    
    static let identifier = "MovieCell"
    
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
        contentView.addSubview(movieImageView)
        contentView.addSubview(titleLabel)
        
        movieImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        // Adiciona um gradiente para melhorar a legibilidade do título
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        gradientLayer.locations = [0.7, 1.0]
        layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = bounds // A frame será atualizada no layoutSubviews
        gradientLayer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Atualiza o frame da layer de gradiente para acompanhar os bounds da célula
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
            movieImageView.image = UIImage(named: "placeholder") // Ou alguma imagem padrão
        }
    }
}
