//
//  WatchlistCoordinator.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 03/06/25.
//


import UIKit

class WatchlistCoordinator: Coordinator {
    var navigationController: NavigationController
    

    var childCoordinators = [Coordinator]()

    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let watchlistViewModel = WatchlistViewModel(coordinator: self)
        let watchlistViewController = WatchlistViewController(viewModel: watchlistViewModel)
        navigationController.setViewControllers([watchlistViewController], animated: false)
    }

    func showWatchedHistory() {
        // Implemente a navegação para o histórico de filmes assistidos
    }
}
