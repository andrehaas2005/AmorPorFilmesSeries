//
//  LancamentoViewModel.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 21/06/25.
//
import Foundation

public class LancamentoViewModel: MovieViewModelProtocol {
    
    var items: Observable<[Movie]> = Observable<[Movie]>([])
    var isLoading = Observable<Bool>(false)
    var errorMessage = Observable<String?>(nil)
    var movieService: MovieServiceProtocol = MovieService.shared
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }
    
    func fetchData() {
        isLoading.value = true
        errorMessage.value = nil
        movieService.fetchRecentlyWatchedMovies { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.items.value = movies
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
