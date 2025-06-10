//
//  ActorsViewModel.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 09/06/25.
//

import Foundation

class ActorsViewModel: ViewModelProtocol {
    var items: Observable<[Actor]> = Observable<[Actor]>()
    
    typealias DataType = Actor
    
    var isLoading: Observable<Bool> = Observable<Bool>(false)
    
    var errorMessage: Observable<String?> = Observable<String?>(nil)
    
    var movieService: (any MovieServiceProtocol)!
    var actorService: (any ActorServiceProtocol)!
    
    init(movieService: (any MovieServiceProtocol)! = MockMovieService(),
         actorService: (any ActorServiceProtocol)!) {
        self.movieService = movieService
        self.actorService = actorService
    }
    
    func fetchData() {
        isLoading.value = true
        errorMessage.value = nil
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        actorService.fetchFamousActors { [weak self] result in
            guard let self = self
            else {return}
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let actors):
                DispatchQueue.main.async {
                    self.items.value = actors
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage.value = "Erro ao carregar filmes para o banner: \(error.localizedDescription)"
                }
            }
        }
    }
}
