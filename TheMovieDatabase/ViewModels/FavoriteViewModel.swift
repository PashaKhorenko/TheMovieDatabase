//
//  FavoriteViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 01.02.2023.
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

class FavoriteViewModel: FavoriteViewModelProtocol {
    
    internal let networkManager: FavoriteNetworkManagerProtocol?
    internal let storageManager: StorageProtocol?
    
    init(networkManager: FavoriteNetworkManagerProtocol?, storageManager: StorageProtocol?) {
        self.networkManager = networkManager
        self.storageManager = storageManager
    }
    
    var favoriteMovies: FavoriteMovies?
    
    func featchFavoriteMovies(_ completion: @escaping () -> ()) {
        guard let accountID = storageManager?.getAccountIDFromStorage(),
              let sessionID = storageManager?.getSessionIDFromStorage() else { return }
        
        networkManager?.downloadFavoriteMovies(accountID: accountID,
                                              sessionID: sessionID) { movies in
            self.favoriteMovies = movies
            completion()
        }
    }
    
    func numberOfItemsInSection() -> Int {
        guard let count = favoriteMovies?.results?.count else { return 0 }
        return count
    }
    
    func removeFromFavorites(movieID: Int, _ completion: @escaping () -> ()) {
        guard let accountID = storageManager?.getAccountIDFromStorage(),
              let sessionID = storageManager?.getSessionIDFromStorage() else { return }
        
        networkManager?.removeFromFavorites(accountID: accountID,
                                           sessionID: sessionID,
                                           movieID: movieID) {
            completion()
        }
    }
    

}
