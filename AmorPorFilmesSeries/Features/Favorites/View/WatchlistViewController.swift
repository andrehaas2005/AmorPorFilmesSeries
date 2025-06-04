//
//  WatchlistViewController.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 03/06/25.
//

import Foundation
import UIKit

class WatchlistViewController: UIViewController {
    
    var viewModel: WatchlistViewModel!
    
    init(viewModel: WatchlistViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil) // <-- CORREÇÃO AQUI
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
