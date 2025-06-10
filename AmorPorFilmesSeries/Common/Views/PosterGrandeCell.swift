//
//  PosterGrande.swift
//  AmorPorFilmesSeries
//
//  Created by Andre Haas on 04/06/25.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit // Importar SnapKit

class PosterGrandeCell: UICollectionViewCell {

    static let identifier = "PosterImageCell"

    let viewBox: UIView = {
        let view = UIView()
        return view
    }()

    var posterImage: UIImageView  = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "movie-placeholder") // Certifique-se que esta imagem existe nos Assets
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    var btnDetai: UIButton  = {
        let btn = UIButton()
        btn.setTitle("Em breve!", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 8 // Arredondar cantos do botão
        return btn
    }()

    var labelName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold) // Aumentei a fonte
        label.textColor = .white // Cor do texto, assumindo fundo escuro
        label.numberOfLines = 2 // Permite múltiplas linhas
        label.textAlignment = .center // Centralizar o texto
        return label
    }()

    // O inicializador padrão para UICollectionViewCell é `init(frame: CGRect)`
    override init(frame: CGRect) {
        super.init(frame: frame) // Chame super.init(frame:)
        setupView() // Chame seu método de configuração aqui
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear // O background da célula deve ser claro para ver o poster

        // 1. Adicione viewBox ao contentView da célula
        contentView.addSubview(viewBox)
        viewBox.snp.makeConstraints { make in
            make.edges.equalToSuperview() // viewBox preenche toda a célula
        }

        // 2. Adicione os outros elementos à viewBox
        viewBox.addSubview(posterImage)
        viewBox.addSubview(btnDetai)
        viewBox.addSubview(labelName)

        // 3. Configure as constraints dos elementos dentro da viewBox
        posterImage.snp.makeConstraints { make in
            make.edges.equalToSuperview() // A imagem preenche toda a viewBox
        }

        // Constraints para o labelName (acima do botão, centralizado)
        labelName.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()//.inset(16) // Margens laterais
            make.bottom.equalTo(btnDetai.snp.top).offset(-16) // Espaçamento entre label e botão
        }

        // Constraints para o btnDetai (centralizado na parte inferior)
        btnDetai.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20) // Distância da parte inferior
            make.width.equalTo(120) // Largura fixa do botão
            make.height.equalTo(44) // Altura fixa do botão
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // Limpe a célula antes de ser reutilizada para evitar dados antigos
        resetCell()
    }

    func cellBuilder (poster: String?, name: String?) {
        labelName.text = name

        // Certifique-se que 'Configuration.imageBaseURL' está definida e é acessível globalmente
        // ou passada como parâmetro. Use Kingfisher para carregar imagens assincronamente.
        if let posterPath = poster, !posterPath.isEmpty,
           let imageURL = URL(string: Configuration.imageBaseURL + posterPath) { // Exemplo de base URL
            posterImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "movie-placeholder"))
        } else {
            posterImage.image = UIImage(named: "movie-placeholder")
        }
    }

    func resetCell() {
        labelName.text = nil
        posterImage.kf.cancelDownloadTask() // Cancela download pendente
        posterImage.image = UIImage(named: "movie-placeholder") // Volta para placeholder
    }
}
