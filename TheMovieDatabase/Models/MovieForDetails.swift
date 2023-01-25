//
//  MovieForDetails.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 24.01.2023.
//

import Foundation

// MARK: - MovieForDetails
struct MovieForDetails: Codable {
    let adult: Bool?
    let posterPath: String?
    let budget: Int?
    let genres: [Genre]?
    let id: Int?
    let originalTitle, overview: String?
    let popularity: Double?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let status, tagline, title: String?
    let video: Bool?

    enum CodingKeys: String, CodingKey {
        case adult
        case posterPath = "poster_path"
        case budget, genres, id
        case originalTitle = "original_title"
        case overview, popularity
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case status, tagline, title, video
    }
}


// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let name: String?
}
