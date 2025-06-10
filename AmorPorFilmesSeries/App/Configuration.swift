//
//  Configuration.swift
//  AmorPorFilmesSeries
//
//  Created by Andre  Haas on 28/05/25.
//


import Foundation

enum Configuration {
    private static let config: NSDictionary? = {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) {
            return dict
        }
        return nil
    }()

    static var baseAPIURL: String {
        return config?["BaseAPIURL"] as? String ?? ""
    }

    static var apiKey: String {
        return config?["APIKey"] as? String ?? ""
    }

    enum Endpoints {
        static var genres: String {
            return (config?["Endpoints"] as? NSDictionary)?["Genres"] as? String ?? ""
        }

        static var nowPlayingMovies: String {
            return (config?["Endpoints"] as? NSDictionary)?["NowPlayingMovies"] as? String ?? ""
        }
        
    }

    static var imageBaseURL: String {
        return config?["ImageBaseURL"] as? String ?? ""
    }
}
