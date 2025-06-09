//
//  PosterViewModel.swift
//  AmorPorFilmesSeries
//
//  Created by Andre Haas on 04/06/25.
//

import Foundation
import ModuloServiceMovie

public class PosterViewModel {

    let upcomingPosterMovies = Observable<[Movie]>([])
    let isLoading = Observable<Bool>(false)
    let errorMessage = Observable<String?>(nil)

    private let movieService: MovieServiceProtocol

    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }


    func fetchPosterData() {
        isLoading.value = true
        errorMessage.value = nil

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()

        // Fetch Upcoming Movies para o poster
        movieService.fetchUpcomingMovies { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let movies):
                // print("PosterViewModel: Movies fetched successfully. Count: \(movies.count)") // Para depuração
                DispatchQueue.main.async {
                    self?.upcomingPosterMovies.value = movies
                }
            case .failure(let error):
                // print("PosterViewModel: Error fetching movies: \(error.localizedDescription)") // Para depuração
                DispatchQueue.main.async {
                    self?.errorMessage.value = "Erro ao carregar filmes para o banner: \(error.localizedDescription)"
                }
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            DispatchQueue.main.async {
                self?.isLoading.value = false
            }
        }
    }
}
