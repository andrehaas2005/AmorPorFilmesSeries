//
//  Utilits.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//

import Foundation

final public class Utilits {
    
    // Função para carregar o arquivo JSON e popular a classe Codable
    private static func carregarJson<T: Codable>(_ meuArquivo: String) -> T? {
        // Localize o arquivo JSON no projeto
        guard let url = Bundle.main.url(forResource: meuArquivo, withExtension: "json") else {
            return nil
        }
        
        do {
            // Carregue o conteúdo do arquivo JSON
            let data = try Data(contentsOf: url)
            
            // Decodifique o JSON em uma lista de objetos
            let objetos = try JSONDecoder().decode(T.self, from: data)
            
            return objetos
        } catch {
            print("Erro ao carregar o arquivo JSON: \(error)")
            return nil
        }
    }
    
    static public func getObject<T: Codable>(_ nomeJson: String) -> [T] {
        guard  let cover: Cover<T> = carregarJson(nomeJson) else {
            return []
        }
        return cover.results
    }
}
