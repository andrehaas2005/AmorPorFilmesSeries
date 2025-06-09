//
//  Coordinator.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//

// App/Coordinator/AppCoordinator.swift
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: NavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: NavigationController // Será usado pelos coordenadores filhos das abas
    
    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // Verifica se o usuário já está logado (simulação)
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn {
            showMainTabBarFlow()
        } else {
            showAuthFlow()
        }
    }
    
    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(
            navigationController: navigationController
        )
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        authCoordinator.start()
    }
    
    private func showMainTabBarFlow() {
        navigationController.viewControllers = []
        childCoordinators.removeAll()
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .systemGreen // Personalize a cor das abas
        tabBarController.tabBar.barTintColor = Color.primaryDark // Cor de fundo da tab bar
        tabBarController.tabBar.isTranslucent = false // Evita transparência indesejada
        
        // MARK: - Configuração das Abas
        // 1. Aba Início (Home)
        let homeNavController = NavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNavController)
        homeCoordinator.delegate = self // AppCoordinator é o delegate do HomeCoordinator
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
        homeNavController.tabBarItem = UITabBarItem(title: "Início", image: UIImage(systemName: "house.fill"), tag: 0)
        homeNavController.navigationBar.prefersLargeTitles = true
        
        // 2. Aba Minha Lista (Watchlist) - Você precisará criar WatchlistCoordinator e WatchlistViewController
        let watchlistNavController = NavigationController()
        let watchlistCoordinator = WatchlistCoordinator(navigationController: watchlistNavController)
        childCoordinators.append(watchlistCoordinator)
        watchlistCoordinator.start()
        watchlistNavController.tabBarItem = UITabBarItem(title: "Minha Lista",
                                                         image: UIImage(systemName: "bookmark.fill"),
                                                         tag: 1)
        watchlistNavController.navigationBar.prefersLargeTitles = true
        
        tabBarController.viewControllers = [
            homeNavController,
            watchlistNavController
        ]
        
        // Define a TabBarController como o root view controller do NavigationController
        // Isso é importante porque o AppCoordinator foi inicializado com um NavigationController.
        // Se o AppCoordinator fosse inicializado com uma UIWindow, a TabBarController seria o root da window.
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func didLogIn(user: User) {
        // Salva o estado de login
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        // Inicia o fluxo da Home
        showMainTabBarFlow()
    }
    
    func didCompleteAuthFlow() {
        // Este método será chamado quando o email for verificado ou o login for bem-sucedido
        // e o fluxo de autenticação for considerado completo.
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        showMainTabBarFlow()
    }
}

extension AppCoordinator: HomeCoordinatorDelegate {
    // Se a Home precisar delegar alguma ação para o AppCoordinator (e.g., logout)
    func didRequestLogout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        childCoordinators.removeAll()  // Remove todos os coordenadores filhos
        showAuthFlow()  // Volta para o fluxo de autenticação
    }
}
