//
//  FavoriteViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 01.02.2023.
//

import Foundation

class FavoriteViewModel {
    
    private let networkManager = FavoriteNetworkManager()
    private let storageManager = StorageManager()
    
    var favoriteMovies: FavoriteMovies?
    
    func featchFavoriteMovies(_ completion: @escaping () -> ()) {
        let accountID = storageManager.getAccountID()
        let sessionID = storageManager.getSessionID()
        
        networkManager.downloadFavoriteMovies(accountID: accountID,
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
        let accountID = storageManager.getAccountID()
        let sessionID = storageManager.getSessionID()
        
        networkManager.removeFromFavorites(accountID: accountID,
                                           sessionID: sessionID,
                                           movieID: movieID) {
            completion()
        }
    }
    

}
