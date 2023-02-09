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
    var moviesDictionary: [Int: [MovieForCollection]] = [:]
    
    func getGenres(_ completion: @escaping () -> ()) {
        networkManager.downloadGenres { [weak self] genres in
            guard let self else { return }
            self.genres = genres
            completion()
        }
    }
    
    func getMovies(_ completion: @escaping () -> ()) {
        for (index, _) in genres.enumerated() {
            self.getMoviesForSection(index) { [weak self] movies in
                guard let self else { return }
                self.moviesDictionary[index] = movies
                
                completion()
            }
        }
    }
    
    private func getMoviesForSection(_ index: Int,
                                     _ completion: @escaping ([MovieForCollection]) -> ()) {
        guard let genreId = self.genres[index].id else {
            print("Failed to get genre id for section \(index)")
            return
        }
        let genreIdString = String(genreId)
        
        networkManager.downloadMoviesByGenre(genreIdString) { data in
            guard let movieArray = data.results else {
                print("It was not possible to get an array of films with the genre \(genreIdString)")
                return
            }
            completion(movieArray)
        }
    }
    
    func numberOfSection() -> Int {
        return genres.count
    }
    
    func numberOfItemsIn(_ section: Int) -> Int {
        guard let array = self.moviesDictionary[section] else { return 0 }
        return array.count
    }

}
