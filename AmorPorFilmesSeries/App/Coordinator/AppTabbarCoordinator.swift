//
//  AppTabbarCoordinator.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 03/06/25.
//

import Foundation


class AppTabbarCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: NavigationController
    var movieCoordinator: HomeCoordinator!
    var watchlistCoordinator: WatchlistCoordinator!
    
    init(childCoordinators: [any Coordinator] = [], navigationController: NavigationController) {
        self.childCoordinators = childCoordinators
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    
}
