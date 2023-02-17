//
//  FavoriteViewModelProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol FavoriteViewModelProtocol {
    var networkManager: FavoriteNetworkManagerProtocol? { get }
    var storageManager: StorageProtocol? { get }
    
    var favoriteMovies: FavoriteMovies? { get set }
    
    func featchFavoriteMovies(_ completion: @escaping () -> ())
    func numberOfItemsInSection() -> Int
    func removeFromFavorites(movieID: Int, _ completion: @escaping () -> ())
}
