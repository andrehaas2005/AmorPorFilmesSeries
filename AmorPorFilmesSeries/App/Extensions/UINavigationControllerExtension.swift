//
//  UINavigationControllerExtension.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//

import UIKit
extension UINavigationController {
    var coordinator: Coordinator? {
        // Isso é uma forma simplificada. Em apps maiores, você pode ter um mapa de coordenadores.
        // Assegure-se de que o AppCoordinator ou um coordenador pai gerencie a vida útil.
        return viewControllers.first?.navigationController?.parent as? Coordinator
    }
}
