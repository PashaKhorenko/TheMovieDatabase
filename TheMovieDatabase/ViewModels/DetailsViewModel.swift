//
//  DetailsViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 24.01.2023.
//

import Foundation

class DetailsViewModel {
    
    private let networkManager = DetailsNetworkManager()
    
    var movie: MovieForDetails?
    
    func getMovie(withID movieID: Int, _ completion: @escaping (MovieForDetails) -> ()) {
        networkManager.downloadMovie(withID: movieID) { [weak self] (movie) in
            guard let self else { return }
            self.movie = movie
            completion(movie)
        }
    }

}
