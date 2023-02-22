//
//  DetailsViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 24.01.2023.
//

import Foundation

class DetailsViewModel: DetailsViewModelProtocol {
    
    internal let networkManager: DetailsNetworkManagerProtocol?
    internal let storageManager: StorageProtocol?
    
    var movie: Dynamic<MovieForDetails?> = Dynamic(nil)
    var videoArray: Dynamic<[Video]> = Dynamic([])
    var posterImageData: Dynamic<Data?> = Dynamic(nil)
    
    init(networkManager: DetailsNetworkManagerProtocol?,
         storageManager: StorageProtocol?) {
        self.networkManager = networkManager
        self.storageManager = storageManager
    }
    
    func getMovie(withID movieID: Int) {
        networkManager?.downloadMovie(withID: movieID) { [weak self] (movie) in
            guard let self else { return }
            self.movie.value = movie
        }
    }
    
    func getImage(byPath path: String?) {
        guard let path else { return }
        networkManager?.downloadImageData(byPath: path) { data in
            self.posterImageData.value = data
        }
    }
    
    func getVideo(byMovieID movieID: Int) {
        networkManager?.downloadVideo(withID: movieID) { [weak self] video in
            self?.videoArray.value = video
        }
    }
    
    func numberOfItemsIn(section: Int) -> Int {
        switch section {
        case 0:
            guard let array = videoArray.value else { return 0 }
            return array.count
        default:
            guard let array = movie.value??.productionCompanies else { return 0 }
            return array.count
        }
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
    
    func markAsFavorites(movieID: Int, _ completion: @escaping (Bool)->()) {
        guard let accountID = storageManager?.getAccountIDFromStorage(),
              let sessionID = storageManager?.getSessionIDFromStorage() else { return }
        
        networkManager?.markAsFavorite(accountID: accountID,
                                       sessionID: sessionID,
                                       movieID: movieID) { statusBool in
            completion(statusBool)
        }
    }
    
    func convertReleaseDateToString(_ releaseDate: String?) -> String {
        guard let releaseDate else { return "Release date: Unknown" }
        return "Release date: \(releaseDate)"
    }
    
    func convertPopularityToString(_ popularity: Double?) -> String {
        guard let popularity else { return "Popularity: Unknown" }
        return "Popularity: \(popularity)"
    }
    
    func convertRuntimeToNormalFormat(_ runtime: Int?) -> String {
        guard let runtime else { return "Runtime: Unknown" }
        
        let hours = runtime / 60
        let minutes = runtime % 60
        
        return "Runtime: \(hours) hour \(minutes) minutes"
    }
    
    func convertBudgetToString(_ budget: Int?) -> String {
        guard let budget else { return "Budget: Unknown" }
        
        if budget == 0 {
            return "Budget: Unknown"
        } else {
            return "Butget: \(budget)$"
        }
    }
    
    func convertRevenueToString(_ revenue: Int?) -> String {
        guard let revenue else { return "Revenue: Unknown" }
        
        if revenue == 0 {
            return "Revenue: Unknown"
        } else {
            return "Revenue: \(revenue)$"
        }
    }
    
    func convertCountriesToString(_ contries: [ProductionCountry]?) -> String {
        var base = "Production contry:"
        
        guard let contries else { return "\(base) Unknown" }
        
        for country in contries {
            guard let name = country.name else { continue }
            base += " \(name),"
        }
        
        return String(base.dropLast())
    }
}
