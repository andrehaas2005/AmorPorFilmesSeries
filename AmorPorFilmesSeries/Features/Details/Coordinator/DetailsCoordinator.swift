//
//  DetailType.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// Features/Details/Coordinator/DetailsCoordinator.swift
import UIKit

// Enum para o tipo de item a ser exibido na tela de detalhes.
enum DetailType {
    case movie(Movie)
    case serie(Serie)
    case actor(Actor)
}

class DetailsCoordinator: Coordinator {
    
    
    
    weak var parentCoordinator: HomeCoordinator? // Pode ser HomeCoordinator ou AppCoordinator, dependendo do fluxo
    var childCoordinators: [Coordinator] = []
    var navigationController: NavigationController

    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }

    /// Inicia o fluxo de detalhes com um item específico.
    func start(with detailType: DetailType) {
        // Em um cenário real, você injetaria um serviço de detalhes aqui.
        let viewModel = DetailsViewModel(detailType: detailType)
        viewModel.coordinator = self // O coordenador é o coordenador do ViewModel

        let viewController = DetailsViewController(viewModel: viewModel)
        // viewController.delegate = self // Se o DetailsViewController precisar delegar algo

        navigationController.pushViewController(viewController, animated: true)
    }

    /// Chamado quando a tela de detalhes é fechada.
    func didFinishDetails() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func start() {}
}
