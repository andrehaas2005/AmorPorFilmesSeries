//
//  HomeCoordinatorDelegate.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Features/Home/Coordinator/HomeCoordinator.swift
import UIKit

// Protocolo para o HomeCoordinator delegar ações de volta ao AppCoordinator.
protocol HomeCoordinatorDelegate: AnyObject {
    func didRequestLogout()
    // Outros eventos que o AppCoordinator precise saber sobre o fluxo da Home.
}

class HomeCoordinator: Coordinator {
    weak var parentCoordinator: AppCoordinator? // Referência fraca ao coordenador pai (AppCoordinator)
    weak var delegate: HomeCoordinatorDelegate? // Delegate para notificar o AppCoordinator
    var childCoordinators: [Coordinator] = [] // Coordenadores filhos (e.g., DetailsCoordinator)
    var navigationController: NavigationController

    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }

    /// Inicia o fluxo da Home.
    func start() {
        let movieService = MockMovieService() //Alterar para serviço real
        
        let viewModel = HomeViewModel(movieService: movieService)
        viewModel.coordinator = self
        let viewController = HomeViewController(viewModel: viewModel)
        viewController.delegate = self
        
        // Define o HomeViewController como a raiz da navigation stack ou o empilha.
        // Se for a primeira tela após o login, geralmente se define como root.
        navigationController.setViewControllers([viewController], animated: true)
    }

    /// Exibe os detalhes de um filme.
    func showMovieDetails(_ movie: Movie) {
        // Cria e inicia um DetailsCoordinator para gerenciar o fluxo de detalhes.
        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController)
        detailsCoordinator.parentCoordinator = self // Define o HomeCoordinator como pai
        childCoordinators.append(detailsCoordinator)
        detailsCoordinator.start(with: .movie(movie)) // Passa o filme para a tela de detalhes
    }

//    /// Exibe os detalhes de uma série.
//    func showSerieDetails(_ serie: Serie) {
//        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController)
//        detailsCoordinator.parentCoordinator = self
//        childCoordinators.append(detailsCoordinator)
//        detailsCoordinator.start(with: .serie(serie)) // Passa a série para a tela de detalhes
//    }
//
//    /// Exibe os detalhes de um ator.
//    func showActorDetails(_ actor: Actor) {
//        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController)
//        detailsCoordinator.parentCoordinator = self
//        childCoordinators.append(detailsCoordinator)
//        detailsCoordinator.start(with: .actor(actor)) // Passa o ator para a tela de detalhes
//    }

    /// Remove um coordenador filho quando seu fluxo é concluído.
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    /// Exemplo de como lidar com um pedido de logout vindo da Home.
    func requestLogout() {
        delegate?.didRequestLogout() // Notifica o AppCoordinator para lidar com o logout.
    }
}

// MARK: - HomeViewControllerDelegate
// O HomeCoordinator conforma ao protocolo do HomeViewController para receber ações da UI.
extension HomeCoordinator: HomeViewControllerDelegate {
    func didSelectMovie(_ movie: Movie) {
        showMovieDetails(movie)
    }

//    func didSelectSerie(_ serie: Serie) {
//        showSerieDetails(serie)
//    }
//
//    func didSelectActor(_ actor: Actor) {
//        showActorDetails(actor)
//    }

    func didRequestLogout() {
        requestLogout()
    }
}
