//
//  ActorsViewModelProtocol.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 22/06/25.
//

import Foundation

protocol ActorsViewModelProtocol: MovieViewModelProtocol {
    var actors: Observable<[ActorMovie]> {get set}
    var actorService: (any ActorServiceProtocol) {get set}
}
