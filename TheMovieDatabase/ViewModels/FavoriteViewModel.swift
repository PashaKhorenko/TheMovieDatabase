//
//  FavoriteViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 01.02.2023.
//

import Foundation

class FavoriteViewModel: FavoriteViewModelProtocol {
    
    internal let networkManager: FavoriteNetworkManagerProtocol?
    internal let storageManager: StorageProtocol?
    
    init(networkManager: FavoriteNetworkManagerProtocol?, storageManager: StorageProtocol?) {
        self.networkManager = networkManager
        self.storageManager = storageManager
    }
    
    var favoriteMovies: Dynamic<[FavoriteMovie]> = Dynamic([])
    
    func featchFavoriteMovies() {
        guard let accountID = storageManager?.getAccountIDFromStorage(),
              let sessionID = storageManager?.getSessionIDFromStorage() else { return }
        
        networkManager?.downloadFavoriteMovies(accountID: accountID,
                                              sessionID: sessionID) { movies in
            self.favoriteMovies.value = movies
        }
    }
    
    func numberOfItemsInSection() -> Int {
        guard let array = favoriteMovies.value else { return 0 }
        return array.count
    }
    
    func removeFromFavorites(movieID: Int) {
        guard let accountID = storageManager?.getAccountIDFromStorage(),
              let sessionID = storageManager?.getSessionIDFromStorage() else { return }
        
        networkManager?.removeFromFavorites(accountID: accountID,
                                           sessionID: sessionID,
                                           movieID: movieID) {
            self.featchFavoriteMovies()
        }
    }
    

}
