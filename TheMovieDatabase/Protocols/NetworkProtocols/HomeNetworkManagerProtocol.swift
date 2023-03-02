//
//  HomeNetworkManagerProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol HomeNetworkManagerProtocol {
    func decoder() -> JSONDecoder
    
    func downloadGenres(_ completion: @escaping ([Genre]) -> Void)
    func downloadMoviesByGenre(_ genreID: String, _ completion: @escaping (MoviesForCollection) -> Void)
}
