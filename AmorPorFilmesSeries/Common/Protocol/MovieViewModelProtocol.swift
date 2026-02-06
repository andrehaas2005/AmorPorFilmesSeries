//
//  ViewModelProtocol.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 09/06/25.
//
import Foundation

protocol MovieViewModelProtocol {
        var isLoading: Observable<Bool> { get set }
        var errorMessage: Observable<String?> { get set }
        var movieService: MovieServiceProtocol { get set }
        var items: Observable<[Movie]> { get set }
        func fetchData()
}
