//
//  SearchMovie.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 08.02.2023.
//

import Foundation

// MARK: - SearchMovies
struct SearchMovies: Decodable {
    let page: Int?
    let results: [SearchMovie]?
    let totalResults, totalPages: Int?
}

// MARK: - Result
struct SearchMovie: Decodable {
    let id: Int?
    let title: String?
    let posterPath: String?
    let overview: String?
}
