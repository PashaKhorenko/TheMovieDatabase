//
//  MovieForDetails.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 24.01.2023.
//

import Foundation

// MARK: - MovieForDetails
struct MovieForDetails: Decodable {
    let adult: Bool?
    let posterPath: String?
    let budget: Int?
    let genres: [Genre]?
    let id: Int?
    let overview: String?
    let popularity: Double?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let title: String?
}


// MARK: - ProductionCompany
struct ProductionCompany: Decodable {
    let logoPath: String?
    let name: String?
}

// MARK: - ProductionCountry
struct ProductionCountry: Decodable {
    let name: String?
}
