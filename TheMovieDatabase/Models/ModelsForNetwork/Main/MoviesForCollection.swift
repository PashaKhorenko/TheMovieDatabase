//
//  Movies.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 23.01.2023.
//

import Foundation

// MARK: - Movies
struct MoviesForCollection: Codable {
    let results: [MovieForCollection]?
}

// MARK: - Movie
struct MovieForCollection: Codable {
    let title: String?
    let originalTitle: String?
    let posterPath: String?
    let genreIDS: [Int]?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case genreIDS = "genre_ids"
        case id
    }
}
