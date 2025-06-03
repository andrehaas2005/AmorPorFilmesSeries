//
//  UIViewExtension.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 30/05/25.
//

import UIKit

enum BackgroundImage: String {
    case sign = "fundo-sign"
    case login = "fundo-login"
    
}


extension UIView {
    func setImageBackgroud(_ imageName: BackgroundImage) {
        let imageBackgroud: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: imageName.rawValue)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        addSubview(imageBackgroud)
        
        NSLayoutConstraint.activate([
            imageBackgroud.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageBackgroud.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            imageBackgroud.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageBackgroud.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
