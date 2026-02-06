//
//  Coordinator.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 22/06/25.
//

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var navigationController: NavigationController { get set }
    func start()
}
