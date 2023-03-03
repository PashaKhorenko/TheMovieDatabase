//
//  FavoritesMovies.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 01.02.2023.
//

import Foundation

// MARK: - FavoriteMovies
struct FavoriteMovies: Decodable {
    let results: [FavoriteMovie]?
}

// MARK: - FavoriteMovie
struct FavoriteMovie: Decodable {
    let id: Int?
    let title: String?
    let originalTitle: String?
    let posterPath: String?
}
