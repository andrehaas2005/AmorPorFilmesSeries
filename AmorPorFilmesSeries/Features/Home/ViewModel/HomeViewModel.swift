//
//  Observable.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Features/Home/ViewModel/HomeViewModel.swift
import Foundation
import ModuloServiceMovie



public class HomeViewModel {
    // Propriedades observáveis para os dados da UI
    let nowPlayingMovies = Observable<[Movie]?>(nil)
    let upcomingMovies = Observable<[Movie]?>(nil)
    let famousActors = Observable<[Actor]?>(nil)
    let recentlyWatchedMovies = Observable<[Movie]?>(nil)
    let lastWatchedSeriesEpisodes = Observable<[Serie]?>(nil)

    let isLoading = Observable<Bool>(false)
    let errorMessage = Observable<String?>(nil)

    weak var coordinator: HomeCoordinator? // Referência fraca ao coordenador

    // Serviços injetados
    private let movieService: MovieServiceProtocol
    private let actorService: ActorServiceProtocol
    private let serieService: SerieServiceProtocol

    // Injeção de dependência dos serviços
    init(movieService: MovieServiceProtocol, actorService: ActorServiceProtocol, serieService: SerieServiceProtocol) {
        self.movieService = movieService
        self.actorService = actorService
        self.serieService = serieService
    }
    
    /// Busca todos os dados necessários para a tela Home.
    func fetchHomeData() {
        isLoading.value = true
        errorMessage.value = nil // Limpa mensagens de erro anteriores

        // Usar DispatchGroup para saber quando todas as chamadas de API foram concluídas.
        let dispatchGroup = DispatchGroup()

        // Fetch Now Playing Movies
        dispatchGroup.enter()
        
        
        DispatchQueue.global().async { [weak self] in
            self?.movieService.fetchNowPlayingMovies { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let movies):
                    // Atualize a UI na thread principal
                    DispatchQueue.main.async {
                        self?.nowPlayingMovies.value = movies
                    }
                case .failure(let error):
                    // Atualize a UI na thread principal
                    DispatchQueue.main.async {
                        self?.errorMessage.value = "Erro ao carregar filmes em cartaz: \(error.localizedDescription)"
                    }
                }
            }
        }
        
        // Fetch Upcoming Movies
        dispatchGroup.enter()
        movieService.fetchUpcomingMovies { [weak self] result in
            defer { dispatchGroup.leave() }
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.upcomingMovies.value = movies
                case .failure(let error):
                    
                    self?.errorMessage.value = "Erro ao carregar filmes em breve: \(error.localizedDescription)"
                }
            }
        }

        // Fetch Famous Actors
        dispatchGroup.enter()
        actorService.fetchFamousActors { [weak self] result in
            defer { dispatchGroup.leave() }
            DispatchQueue.main.async {
                switch result {
                case .success(let actors):
                    self?.famousActors.value = actors
                case .failure(let error):
                    self?.errorMessage.value = "Erro ao carregar atores: \(error.localizedDescription)"
                }
            }
        }

        // Fetch Recently Watched Movies
        dispatchGroup.enter()
        movieService.fetchRecentlyWatchedMovies { [weak self] result in
            defer { dispatchGroup.leave() }
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.recentlyWatchedMovies.value = movies
                case .failure(let error):
                    self?.errorMessage.value = "Erro ao carregar filmes assistidos recentemente: \(error.localizedDescription)"
                }
            }
        }

        // Fetch Last Watched Series Episodes
        dispatchGroup.enter()
        serieService.fetchLastWatchedSeriesEpisodes { [weak self] result in
            defer { dispatchGroup.leave() }
            DispatchQueue.main.async {
                switch result {
                case .success(let series):
                    self?.lastWatchedSeriesEpisodes.value = series
                case .failure(let error):
                    self?.errorMessage.value = "Erro ao carregar últimos episódios de séries: \(error.localizedDescription)"
                }
            }
        }

        // Notifica quando todas as chamadas de API foram concluídas.
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

    /// Notifica o coordenador que uma série foi selecionada.
    func didSelectSerie(_ serie: Serie) {
        coordinator?.showSerieDetails(serie)
    }

    /// Notifica o coordenador que um ator foi selecionado.
    func didSelectActor(_ actor: Actor) {
        coordinator?.showActorDetails(actor)
    }
}
