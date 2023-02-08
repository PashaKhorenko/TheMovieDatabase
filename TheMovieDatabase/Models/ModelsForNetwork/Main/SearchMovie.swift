//
//  SearchMovie.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 08.02.2023.
//

import Foundation

// MARK: - SearchMovies
struct SearchMovies: Codable {
    let page: Int?
    let results: [SearchMovie]?
    let totalResults, totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

// MARK: - Result
struct SearchMovie: Codable {
    let id: Int?
    let title: String?
    let posterPath: String?
    let overview: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case overview
    }
}
