//
//  MockActorService.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Services/MockActorService.swift
import Foundation

final class MockActorService: ActorServiceProtocol {
    func fetchFamousActors(completion: @escaping (Result<[Actor], Error>) -> Void) {
        DispatchQueue(label: "Mock").asyncAfter(deadline: .now() + 1.1, execute: {
            completion(.success(Utilits.getObject("ListActorsPopular")))
        })
    }
}
