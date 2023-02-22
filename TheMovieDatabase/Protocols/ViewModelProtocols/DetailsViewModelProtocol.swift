//
//  DetailsViewModelProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol DetailsViewModelProtocol {
    var networkManager: DetailsNetworkManagerProtocol? { get }
    var storageManager: StorageProtocol? { get }
    
    var movie: Dynamic<MovieForDetails?> { get set }
    var videoArray: Dynamic<[Video]> { get set }
    var posterImageData: Dynamic<Data?> { get set }
    
    func getMovie(withID movieID: Int)
    func getVideo(byMovieID movieID: Int)
    func getImage(byPath path: String?)
    
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
