//
//  HomeViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 23.01.2023.
//

import Foundation

class HomeViewModel {
    
    private let networkManager = HomeNetworkManager()
    
    var genres: [Genre] = []
    var movies: [MovieForCollection] = []
    
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
        var count = 0
        
        guard let sectionGenreID = genres[section].id else { return count }
                
        for movie in movies {
            guard let movieGenreIDs = movie.genreIDS else { return count}
            if movieGenreIDs.contains(sectionGenreID) {
                count += 1
            }
        }
        
        return count
    }
}
