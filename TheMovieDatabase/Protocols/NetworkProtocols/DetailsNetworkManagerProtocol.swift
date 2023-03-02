//
//  DetailsNetworkManagerProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol DetailsNetworkManagerProtocol {
    
    func decoder() -> JSONDecoder
    
    func downloadMovie(withID movieID: Int, _ completion: @escaping (MovieForDetails) -> Void)
    func downloadImageData(byPath path: String, _ completion: @escaping (Data) -> ())
    func downloadVideo(withID movieId: Int, _ completion: @escaping ([Video]) -> ())
    
    func markAsFavorite(accountID: Int,
                        sessionID: String,
                        movieID: Int,
                        _ completion: @escaping (Bool) -> ())
}
