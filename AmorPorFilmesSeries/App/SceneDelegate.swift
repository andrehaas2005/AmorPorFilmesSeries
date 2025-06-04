//
//  SceneDelegate.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 28/05/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
              let window = UIWindow(windowScene: windowScene)
              self.window = window // Atribui à propriedade 'window' do SceneDelegate.
              let navigationController = NavigationController()
              appCoordinator = AppCoordinator(navigationController: navigationController)
              appCoordinator?.start()
              window.rootViewController = navigationController
              window.makeKeyAndVisible()

              print("SceneDelegate: scene willConnectTo")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
       
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
       
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}
