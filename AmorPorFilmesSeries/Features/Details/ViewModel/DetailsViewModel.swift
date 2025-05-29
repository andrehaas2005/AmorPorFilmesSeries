//
//  DetailsViewModel.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Features/Details/ViewModel/DetailsViewModel.swift
import Foundation

class DetailsViewModel {
    let detailType: DetailType
    let title = Observable<String?>(nil)
    let description = Observable<String?>(nil)
    let imageUrl = Observable<URL?>(nil)

    weak var coordinator: DetailsCoordinator?

    init(detailType: DetailType) {
        self.detailType = detailType
        // Configura os dados iniciais com base no tipo de detalhe.
        setupDetails(for: detailType)
    }

    private func setupDetails(for type: DetailType) {
        
        switch type {
        case .movie(let movie):
            title.value = movie.title
            description.value = movie.overview
            imageUrl.value = URL(string: Configuration.imageBaseURL + movie.posterPath)
        case .serie(let serie):
            title.value = serie.name
            description.value = serie.overview
            imageUrl.value =  URL(string: serie.posterPath)
        case .actor(let actor):
            title.value = actor.name
            description.value = "Informações detalhadas sobre o ator." // Buscar mais detalhes da API
            imageUrl.value = actor.name.isEmpty ? nil : URL(string: "https://image.tmdb.org/t/p/w500/\(actor.profilePath)")
        }
        // Em um cenário real, faria uma chamada de API para buscar detalhes completos aqui.
    }
}
