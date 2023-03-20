//
//  FavoriteViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 01.02.2023.
//

import Foundation

class FavoriteViewModel: FavoriteViewModelProtocol {
    
    let networkManager: FavoriteNetworkManagerProtocol?
    let storageManager: StorageProtocol?
    
    init(networkManager: FavoriteNetworkManagerProtocol?, storageManager: StorageProtocol?) {
        self.networkManager = networkManager
        self.storageManager = storageManager
    }
    
    var favoriteMovies: Dynamic<[FavoriteMovie]> = Dynamic([])
    
    func getMessagesDependingOnTheSessionType() -> String {
        guard let sessionType = self.storageManager?.getSessionType() else {
            return "This list is empty"
        }
        
        switch sessionType {
        case .guest:
            return "Unfortunately, the list of favorite movies\n is not available in guest mode. Log in to your account to see a list of your favorite movies."
        case .authorized:
            return "Sorry but your favorite movies list is empty.\n Add some movies and you will see them here."
        }
    }
    
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
