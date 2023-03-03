//
//  SearchNetworkManagerProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol SearchNetworkManagerProtocol {
    func decoder() -> JSONDecoder
    func searchMoviesBy(_ query: String, _ completion: @escaping (SearchMovies) -> ())
}
