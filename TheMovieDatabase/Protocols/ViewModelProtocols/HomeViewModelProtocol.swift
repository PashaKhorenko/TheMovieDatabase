//
//  HomeViewModelProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var networkManager: HomeNetworkManagerProtocol? { get }
    
    var genres: [Genre] { get set }
    var moviesDictionary: [Int: [MovieForCollection]] { get set }
    
    func getGenres(_ completion: @escaping () -> ())
    func getMovies(_ completion: @escaping () -> ())
    
    func getMoviesForSection(_ index: Int,
                             _ completion: @escaping ([MovieForCollection]) -> ())
    
    func numberOfSection() -> Int
    func numberOfItemsIn(_ section: Int) -> Int
}
