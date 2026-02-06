//
//  ActorService.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 12/06/25.
//

import Foundation
import Alamofire

internal class ActorServiceWithAlamofire: ActorServiceProtocol {
    
    static let shared = ActorServiceWithAlamofire()
    
    func fetchFamousActors(completion: @escaping (Result<[ActorMovie], any Error>) -> Void) {
        
    }
}
