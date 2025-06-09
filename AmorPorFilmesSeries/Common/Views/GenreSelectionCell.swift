//
//  GenreSelectionCell.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Common/Views/GenreSelectionCell.swift
import UIKit

class GenreSelectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GenreSelectionCell"

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    override convenience init(frame: CGRect) {
        self.init(frame: .zero)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func setupCell() {
        contentView.addSubview(genreLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])

        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }

    func configure(with genreName: String, isSelected: Bool) {
        genreLabel.text = genreName
        if isSelected {
            contentView.backgroundColor = .systemBlue
            genreLabel.textColor = .white
            contentView.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            contentView.backgroundColor = .systemTeal
            genreLabel.textColor = .white
            contentView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
}
