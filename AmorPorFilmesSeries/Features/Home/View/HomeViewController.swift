//
//  HomeViewController.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre Haas on 28/05/25.
//

import Kingfisher
import UIKit
import SnapKit

protocol HomeViewControllerDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
    func didRequestLogout()
}

enum Section {
    case main
    case second
}

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    weak var delegate: HomeViewControllerDelegate?
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setImageBackgroud(.home)
        self.viewModel.delegateLancamento =
        posterMovie as? LancamentoViewControllerDelegate
        self.viewModel.delegateFetchNowPlayingMovies =
        nowPlayingCollectionView.self as? LancamentoViewControllerDelegate
        setupLogoutButton()
        setupUI()
        viewModel.fetchData()
    }
    
    func setupLogoutButton() {
        if #available(iOS 13.0, *) {
            let logoutImage = UIImage(systemName: "rectangle.portrait.and.arrow.right")
            let logoutBarButtonItem = UIBarButtonItem(image: logoutImage, style: .plain,
                                                      target: self, action: #selector(logoutTapped))
            navigationItem.rightBarButtonItem = logoutBarButtonItem
        } else {
            if let logoutImage = UIImage(named: "logout_icon") {
                let logoutBarButtonItem = UIBarButtonItem(image: logoutImage, style: .plain,
                                                          target: self, action: #selector(logoutTapped))
                navigationItem.rightBarButtonItem = logoutBarButtonItem
            } else {
                let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain,
                                                          target: self, action: #selector(logoutTapped))
                navigationItem.rightBarButtonItem = logoutBarButtonItem
            }
        }
    }
    
    @objc func logoutTapped() {
        delegate?.didRequestLogout()
    }
    
    private func setupBrind() {
        
    }
    
    
    

}
