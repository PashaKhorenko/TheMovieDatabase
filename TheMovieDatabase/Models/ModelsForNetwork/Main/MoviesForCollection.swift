//
//  Movies.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 23.01.2023.
//

import Foundation

// MARK: - Movies
struct MoviesForCollection: Decodable {
    let results: [MovieForCollection]?
}

// MARK: - Movie
struct MovieForCollection: Decodable {
    let title: String?
    let originalTitle: String?
    let posterPath: String?
    let genreIDS: [Int]?
    let id: Int?
}
