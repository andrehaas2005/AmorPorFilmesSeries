//
//  HomeViewModel.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 03/06/25.
//


//
//  Observable.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Features/Home/ViewModel/HomeViewModel.swift
import Foundation
import ModuloServiceMovie



public class WatchlistViewModel {
    // Propriedades observáveis para os dados da UI
    let nowPlayingMovies = Observable<[Movie]?>(nil)
    let upcomingMovies = Observable<[Movie]?>(nil)
    let famousActors = Observable<[Actor]?>(nil)
    let recentlyWatchedMovies = Observable<[Movie]?>(nil)
    let lastWatchedSeriesEpisodes = Observable<[Serie]?>(nil)
    
    let isLoading = Observable<Bool>(false)
    let errorMessage = Observable<String?>(nil)
    
    weak var coordinator: WatchlistCoordinator? // Referência fraca ao coordenador
    
    
    // Injeção de dependência dos serviços
    init(coordinator: WatchlistCoordinator) {
        self.coordinator = coordinator
    }
    
    /// Busca todos os dados necessários para a tela Home.
    func fetchHomeData() {

    }
    
    /// Notifica o coordenador que um filme foi selecionado.
    func didSelectMovie(_ movie: Movie) {
        print(movie.title)
    }
    
    /// Notifica o coordenador que uma série foi selecionada.
    func didSelectSerie(_ serie: Serie) {
        print(serie.name)
    }
    
    /// Notifica o coordenador que um ator foi selecionado.
    func didSelectActor(_ actor: Actor) {
        print(actor.name)
    }
}
