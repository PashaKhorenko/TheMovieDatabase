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
