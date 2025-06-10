//
//  ActorsCell.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 09/06/25.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class ActorsCell: UICollectionViewCell, CollectionViewCellProtocol {
    
    var items: (poster: String?, name: String?, fantasiaNameText: String?)
    
    typealias DataType = (poster: String?, name: String?, fantasiaNameText: String?)
    static var identifier: String = "ActorsCell"
    
    
    let viewBox: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var posterImage: UIImageView  = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "movie-placeholder") // Certifique-se que esta imagem existe nos Assets
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = label.font.withSize(15)
        return label
    }()
    
    var fantasiaName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        viewBox.addSubview(posterImage)
        viewBox.addSubview(nameLabel)
        viewBox.addSubview(fantasiaName)
        contentView.addSubview(viewBox)
        
        viewBox.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(100)
        }
        
        posterImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(posterImage.snp.bottom).inset(-8)
        }
        
        fantasiaName.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nameLabel.snp.bottom).inset(8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    func resetCell() {
        nameLabel.text = nil
        fantasiaName.text = nil
        posterImage.kf.cancelDownloadTask() // Cancela download pendente
        posterImage.image = UIImage(named: "movie-placeholder") // Volta para placeholder
    }
    func cellBuilder(items: (poster: String?, name: String?, fantasiaNameText: String?)) {
        nameLabel.text = items.name
        fantasiaName.text = items.fantasiaNameText
        if let posterPath = items.poster, !posterPath.isEmpty,
           let imageURL = URL(string: Configuration.imageBaseURL + posterPath) {
            posterImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "movie-placeholder"))
        } else {
            posterImage.image = UIImage(named: "movie-placeholder")
        }
    }
}
