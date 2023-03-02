//
//  FavoritesStatusResponse.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 01.02.2023.
//

import Foundation

// MARK: - FavoritesStatusResponse
struct FavoritesStatusResponse: Decodable {
    let statusCode: Int?
    let statusMessage: String?
}
