//
//  FavoriteNetworkManagerProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol FavoriteNetworkManagerProtocol {
    func downloadFavoriteMovies(accountID: Int,
                                sessionID: String,
                                _ completion: @escaping ([FavoriteMovie]) -> ())
    
    func removeFromFavorites(accountID: Int,
                             sessionID: String,
                             movieID: Int,
                             _ completion: @escaping () -> ())
}
