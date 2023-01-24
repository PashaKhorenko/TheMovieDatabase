//
//  Movies.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 23.01.2023.
//

import Foundation

// MARK: - Movies
struct MoviesForCollection: Codable {
    let page: Int?
    let results: [MovieForCollection]?
    let totalResults, totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

// MARK: - Movie
struct MovieForCollection: Codable {
    let posterPath: String?
    let genreIDS: [Int]?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case genreIDS = "genre_ids"
        case id
    }
}
