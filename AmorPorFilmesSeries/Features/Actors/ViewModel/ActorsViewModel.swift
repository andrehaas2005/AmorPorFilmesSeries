//
//  ActorsViewModel.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 09/06/25.
//

import Foundation

class ActorsViewModel: ActorsViewModelProtocol {
    var actors: Observable<[ActorMovie]> = Observable([])
    var items: Observable<[Movie]> = Observable([])
    var actorService: any ActorServiceProtocol
    
    var isLoading: Observable<Bool> = Observable(false)
    
    var errorMessage: Observable<String?> = Observable(nil)
    
    var movieService: any MovieServiceProtocol =  MockMovieService()
    
    init(actorService: (any ActorServiceProtocol) = MockActorService()) {
        self.actorService = actorService
    }
    
    func fetchData() {
        isLoading.value = true
        errorMessage.value = nil
        
        actorService.fetchFamousActors { [weak self] result in
            switch result {
            case .success(let actors):
                DispatchQueue.main.async {
                    self?.actors.value = actors
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage.value = "Erro ao carregar filmes para o banner: \(error.localizedDescription)"
                }
            }
            DispatchQueue.main.async {
                self?.isLoading.value = false
            }
        }
    }
}
