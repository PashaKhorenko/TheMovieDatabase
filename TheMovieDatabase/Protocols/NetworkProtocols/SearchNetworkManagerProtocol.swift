//
//  SearchNetworkManagerProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol SearchNetworkManagerProtocol {
    func seacthMoviesBy(_ query: String, _ completion: @escaping (SearchMovies) -> ())
}
