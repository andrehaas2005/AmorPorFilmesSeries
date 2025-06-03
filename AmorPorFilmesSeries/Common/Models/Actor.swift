//
//  Cover.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cover = try? JSONDecoder().decode(Cover.self, from: jsonData)

import Foundation



// MARK: - Result
struct Actor: Codable {
    let adult: Bool
    let gender, id: Int
    let knownForDepartment: KnownForDepartment
    let name, originalName: String
    let popularity: Double
    let profilePath: String
    let knownFor: [KnownFor]

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
}

// MARK: - KnownFor
struct KnownFor: Codable {
    let backdropPath: String
    let id: Int
    let title, originalTitle: String?
    let overview, posterPath: String
    let mediaType: MediaType
    let adult: Bool
    let originalLanguage: OriginalLanguage
    let genreIDS: [Int]
    let popularity: Double
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    let name, originalName, firstAirDate: String?
    let originCountry: [OriginCountry] = []

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
    }
}

enum MediaType: String, Codable {
    case movie
    case tv
}

enum OriginCountry: String, Codable {
    case gb = "GB"
    case us = "US"
    case br = "BR"
}

enum OriginalLanguage: String, Codable {
    case en
    case pt
}

enum KnownForDepartment: String, Codable {
    case acting = "Acting"
}
