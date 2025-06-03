//
//  Observable.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//
import Combine
import Foundation

// Classe auxiliar para observáveis (se não estiver usando Combine ou similar)
class Observable<T> {
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    private var listener: ((T?) -> Void)?
    init(_ value: T? = nil) {
        self.value = value
    }
    func bind(_ listener: @escaping (T?) -> Void) {
        self.listener = listener
        listener(value)
    }
}
