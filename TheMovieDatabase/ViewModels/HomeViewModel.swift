//
//  HomeViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 23.01.2023.
//

import Foundation

class HomeViewModel {
    
    private let networkManager = HomeNetworkManager()
    
    var genres: [GenreServerResponse] = []
    var movies: [Movie] = []
    
    func getGenres(_ completion: @escaping () -> ()) {
        networkManager.downloadGenres { [weak self] genres in
            guard let self else { return }
            self.genres = genres
            completion()
        }
    }
    
    func getMovies(_ completion: @escaping () -> ()) {
        for page in 1...5 {
            networkManager.downloadMovies(fromPage: page) { [weak self] moviesRespose in
                guard let self,
                      let movies = moviesRespose.results else { return }
                
                for movie in movies {
                    self.movies.append(movie)
                }
                completion()
            }
        }
    }
    
    func numberOfSection() -> Int {
        return genres.count
    }
    
    func numberOfItemsIn(_ section: Int) -> Int {
        guard let genreID = genres[section].id else { return 0 }
                
        var count = 0
        
        for movie in movies {
            for movieGengeID in movie.genreIDS! {
                if movieGengeID == genreID {
                    count += 1
                }
            }
        }
        
        return count
    }
}
