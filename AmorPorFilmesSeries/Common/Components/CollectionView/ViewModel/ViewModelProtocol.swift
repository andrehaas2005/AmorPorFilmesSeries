//
//  ViewModelProtocol.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 09/06/25.
//


protocol ViewModelProtocol {
    var isLoading: Observable<Bool> { get set}
    var errorMessage: Observable<String?> {get set}
    var movieService: MovieServiceProtocol! {get set}
    associatedtype DataType
    var items: Observable<[DataType]> { get set }
    mutating func fetchData()
    
}