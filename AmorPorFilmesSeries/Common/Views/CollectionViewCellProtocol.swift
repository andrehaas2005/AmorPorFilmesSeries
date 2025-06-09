//
//  CollectionViewCellProtocol.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 09/06/25.
//

import UIKit



protocol CollectionViewCellProtocol {

    associatedtype DataType
    var items: DataType {get set}
    func setupCell()
    func resetCell()
    func cellBuilder(items: DataType)
    static var identifier: String {get}
    
    func prepareForReuse()

}

extension CollectionViewCellProtocol {
    func prepareForReuse() {
        resetCell()
    }
}

