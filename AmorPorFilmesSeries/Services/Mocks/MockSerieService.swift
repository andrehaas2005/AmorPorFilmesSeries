//
//  MockSerieService.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Services/MockSerieService.swift
import Foundation

class MockSerieService: SerieServiceProtocol {
    func fetchLastWatchedSeriesEpisodes(completion: @escaping (Result<[Serie], Error>) -> Void) {
        DispatchQueue(label: "Mock").asyncAfter(deadline: .now() + 1.1, execute: {
            completion(.success(Utilits.getObject("ListaSeriesPopular")))
        })
    }
}
