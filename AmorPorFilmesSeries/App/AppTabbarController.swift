//
//  AppTabbarControllerViewController.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 03/06/25.
//

import UIKit

class AppTabbarController: UITabBarController {
    
    var nagivationController: NavigationController! = NavigationController()
    var coodinators: [Coordinator] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = AppTabbarController()
//        vc.setViewControllers(coodinators, animated: true)
        nagivationController.setRootViewController(vc)
    }

}
