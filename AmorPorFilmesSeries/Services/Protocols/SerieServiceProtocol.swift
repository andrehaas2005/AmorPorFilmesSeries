//
//  SerieServiceProtocol.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Services/Protocols/SerieServiceProtocol.swift
import Foundation

// Define o protocolo para o serviço de séries.
protocol SerieServiceProtocol {
    /// Busca os últimos episódios de séries que o usuário assistiu e não finalizou.
    func fetchLastWatchedSeriesEpisodes(completion: @escaping (Result<[Serie], Error>) -> Void)
}