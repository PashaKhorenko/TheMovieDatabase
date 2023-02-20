//
//  HomeViewModelProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var networkManager: HomeNetworkManagerProtocol? { get }
    
    var genres: Dynamic<[Genre]> { get set }
    var moviesDictionary: Dynamic<[Int: [MovieForCollection]]> { get set }
    
    func getGenres()
    func getMovies()
    
    func getMoviesForSection(_ index: Int,
                             _ completion: @escaping ([MovieForCollection]) -> ())
    
    func numberOfSection() -> Int
    func numberOfItemsIn(_ section: Int) -> Int
}
