//
//  DetailsViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 24.01.2023.
//

import Foundation

protocol DetailsViewModelProtocol {
    var networkManager: DetailsNetworkManagerProtocol? { get }
    var storageManager: StorageProtocol? { get }
    
    var movie: MovieForDetails? { get set }
    var videoArray: Video? { get set }
    
    func getMovie(withID movieID: Int, _ completion: @escaping (MovieForDetails) -> ())
    func getImage(byPath path: String?, completion: @escaping (Data) -> ())
    func getVideo(byMovieID movieID: Int, _ completion: @escaping () -> ())
    
    func numberOfItemsIn(section: Int) -> Int
    
    func getGenreNamesFrom(list: [Genre]?) -> String
    func getAgeRestrictions(_ adult: Bool?) -> String
    func markAsFavorites(movieID: Int, _ completion: @escaping (Bool)->())
    
    func convertReleaseDateToString(_ releaseDate: String?) -> String
    func convertPopularityToString(_ popularity: Double?) -> String
    func convertRuntimeToNormalFormat(_ runtime: Int?) -> String
    func convertBudgetToString(_ budget: Int?) -> String
    func convertRevenueToString(_ revenue: Int?) -> String
    func convertCountriesToString(_ contries: [ProductionCountry]?) -> String
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    internal let networkManager: DetailsNetworkManagerProtocol?
    internal let storageManager: StorageProtocol?
    
    var movie: MovieForDetails?
    var videoArray: Video?
    
    init(networkManager: DetailsNetworkManagerProtocol?,
         storageManager: StorageProtocol?,
         movie: MovieForDetails? = nil,
         videoArray: Video? = nil) {
        self.networkManager = networkManager
        self.storageManager = storageManager
        self.movie = movie
        self.videoArray = videoArray
    }
    
    func getMovie(withID movieID: Int, _ completion: @escaping (MovieForDetails) -> ()) {
        networkManager?.downloadMovie(withID: movieID) { [weak self] (movie) in
            guard let self else { return }
            self.movie = movie
            completion(movie)
        }
    }
    
    func getImage(byPath path: String?, completion: @escaping (Data) -> ()) {
        guard let path else { return }
        networkManager?.downloadImageData(byPath: path) { data in
            completion(data)
        }
    }
    
    func getVideo(byMovieID movieID: Int, _ completion: @escaping () -> ()) {
        networkManager?.downloadVideo(withID: movieID) { [weak self] video in
            self?.videoArray = video
            completion()
        }
    }
    
    func numberOfItemsIn(section: Int) -> Int {
        switch section {
        case 0:
            guard let count = videoArray?.results?.count else { return 0 }
            return count
        default:
            guard let count = movie?.productionCompanies?.count else { return 0 }
            return count
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
