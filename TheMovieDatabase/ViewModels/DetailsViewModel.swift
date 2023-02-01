//
//  DetailsViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 24.01.2023.
//

import Foundation

class DetailsViewModel {
    
    private let networkManager = DetailsNetworkManager()
    private let storageManager = StorageManager()
    
    var movie: MovieForDetails?
    var videoArray: Video?
    
    func getMovie(withID movieID: Int, _ completion: @escaping (MovieForDetails) -> ()) {
        networkManager.downloadMovie(withID: movieID) { [weak self] (movie) in
            guard let self else { return }
            self.movie = movie
            completion(movie)
        }
    }
    
    func getImage(byPath path: String?, completion: @escaping (Data) -> ()) {
        guard let path else { return } 
        networkManager.downloadImageData(byPath: path) { data in
            completion(data)
        }
    }
    
    func getVideo(byMovieID movieID: Int, _ completion: @escaping () -> ()) {
        networkManager.downloadVideo(withID: movieID) { [weak self] video in
            self?.videoArray = video
            completion()
        }
    }
    
    func numberOfItemsInSection() -> Int {
        guard let count = videoArray?.results?.count else { return 0 }
        return count
    }
    
    func getGenreNamesFrom(list: [Genre]?) -> String {
        guard let movieGenres = list else {
            return "Unknown"
        }
        
        var result = "Genre: "
        
        for genre in movieGenres {
            guard let genreName = genre.name else { return "" }
            result.append("\(genreName), ")
        }
        
        return String(result.dropLast(2))
    }
    
    func getAgeRestrictions(_ adult: Bool?) -> String {
        guard let isForAdult = adult else {
            return "Age restrictions: Unknown"
        }
        
        switch isForAdult {
        case true: return "Age restrictions: Children are prohibited"
        case false: return "Age restrictions: Missing"
        }
    }
    
    func markAsFavorites(movieID: Int, status: Bool, _ completion: @escaping (Bool)->()) {
        let accountID = storageManager.getAccountID()
        let sessionID = storageManager.getSessionID()
        
        networkManager.markAsFavorite(accountID: accountID,
                                      sessionID: sessionID,
                                      movieID: movieID,
                                      status: status) { statusBool in
            completion(statusBool)
        }
    }
}
