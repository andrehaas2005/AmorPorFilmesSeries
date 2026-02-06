//
//  PosterViewModel.swift
//  AmorPorFilmesSeries
//
//  Created by Andre Haas on 04/06/25.
//

import Foundation
import ModuloServiceMovie



public class PosterViewModel: MovieViewModelProtocol {
    var items: Observable<[Movie]> = Observable<[Movie]>([])
    var isLoading = Observable<Bool>(false)
    var errorMessage = Observable<String?>(nil)

    internal var movieService: MovieServiceProtocol

    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }


    func fetchData() {
        isLoading.value = true
        errorMessage.value = nil
        movieService.fetchUpcomingMovies { [weak self] result in
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
