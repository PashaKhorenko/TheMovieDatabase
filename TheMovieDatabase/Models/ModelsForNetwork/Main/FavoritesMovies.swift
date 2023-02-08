//
//  FavoritesMovies.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 01.02.2023.
//

import Foundation

// MARK: - FavoriteMovies
struct FavoriteMovies: Codable {
    let results: [FavoriteMovie]?
}

// MARK: - FavoriteMovie
struct FavoriteMovie: Codable {
    let id: Int?
    let title: String?
    let posterPath: String?
    

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }
}
