//
//  Observable.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


import Foundation
import ModuloServiceMovie

public class HomeViewModel: ViewModelProtocol {
    typealias DataType = Movie
    internal var movieService: (any MovieServiceProtocol)!
    
    var isLoading: Observable<Bool> = Observable<Bool>(false)
    var items: Observable<[Movie]> = Observable<[Movie]>()
    var errorMessage: Observable<String?> = Observable<String?>()
    weak var coordinator: HomeCoordinator?
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }
    
    func fetchData() {
        isLoading.value = true
        errorMessage.value = nil // Limpa mensagens de erro anteriores
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.global().async { [weak self] in
            self?.movieService.fetchNowPlayingMovies { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        self?.items.value = movies
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorMessage.value = "Erro ao carregar filmes em cartaz: \(error.localizedDescription)"
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            DispatchQueue.main.async {
                self?.isLoading.value = false
            }
        }
    }
    
    /// Notifica o coordenador que um filme foi selecionado.
    func didSelectMovie(_ movie: Movie) {
        coordinator?.showMovieDetails(movie)
    }
}
