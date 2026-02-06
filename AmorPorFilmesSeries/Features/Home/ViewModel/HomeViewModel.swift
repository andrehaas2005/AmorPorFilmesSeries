//
//  Observable.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


import Foundation
import ModuloServiceMovie

public class HomeViewModel {
    internal var movieService: MovieServiceProtocol
    
    var isLoading: Observable<Bool> = Observable<Bool>(false)
    
    var fetchRecentlyWatchedMoviesModel = [Movie]()
    var fetchUpcomingMoviesModel = [Movie]()
    var fetchNowPlayingMoviesModel = [Movie]()
    var errorMessage = String()
    var delegateLancamento: LancamentoViewControllerDelegate?
    var delegateFetchNowPlayingMovies: LancamentoViewControllerDelegate?
    
    weak var coordinator: HomeCoordinator?
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = NetworkAFMovieService()
    }
    
    func fetchData() {
        isLoading.value = true
        
        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//        movieService.fetchRecentlyWatchedMovies { result in
//            dispatchGroup.leave()
//            switch result {
//            case .success(let movies):
//                print(separator: "=")
//                print(movies)
//                DispatchQueue.main.async {
//                    self.fetchRecentlyWatchedMoviesModel = movies
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.errorMessage = "Erro ao carregar filmes em cartaz: \(error.localizedDescription)"
//                    print("fetchRecentlyWatchedMovies ==> " , self.errorMessage)
//                }
//            }
//            DispatchQueue.main.async {
//                self.isLoading.value = false
//            }
//            
//        }
        
        
        dispatchGroup.enter()
        movieService.fetchUpcomingMovies { result in
            dispatchGroup.leave()
            switch result {
            case .success(let listUpcomingMovies):
                print(separator: "=")
                print(listUpcomingMovies)
                self.fetchUpcomingMoviesModel = listUpcomingMovies
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Erro ao carregar filmes em cartaz: \(error.localizedDescription)"
                    print("fetchUpcomingMovies ==> ", self.errorMessage)
                }
            }
        }
        
        
        dispatchGroup.enter()
        movieService.fetchNowPlayingMovies { result in
            dispatchGroup.leave()
            switch result {
            case .success(let movie):
               self.fetchNowPlayingMoviesModel = movie
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Erro ao carregar filmes em cartaz: \(error.localizedDescription)"
                    print("fetchNowPlayingMovies ==> ", self.errorMessage)
                }
            }
            
        }
        
        dispatchGroup.notify(queue: .main) {
            print(separator: "***")
            print("FInalizado todas as chamadas !!!")
            self.delegateLancamento?.updateMovie(self.fetchUpcomingMoviesModel)
            self.delegateFetchNowPlayingMovies?.updateMovie(self.fetchUpcomingMoviesModel)
        }
    }
    
    /// Notifica o coordenador que um filme foi selecionado.
    func didSelectMovie(_ movie: Movie) {
        coordinator?.showMovieDetails(movie)
    }
}
