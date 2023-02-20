//
//  HomeViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 23.01.2023.
//

import Foundation

class HomeViewModel: HomeViewModelProtocol {
    
    internal let networkManager: HomeNetworkManagerProtocol?

    init(networkManager: HomeNetworkManagerProtocol?) {
        self.networkManager = networkManager
    }
    
    var genres: Dynamic<[Genre]> = Dynamic([])
    var moviesDictionary: Dynamic<[Int: [MovieForCollection]]> = Dynamic([:])
    
    func getGenres() {
        networkManager?.downloadGenres { [weak self] genres in
            self?.genres.value = genres
        }
    }
    
    func getMovies() {
        guard let array = genres.value else { return }
        
        for (index, _) in array.enumerated() {
            self.getMoviesForSection(index) { [weak self] movies in
                self?.moviesDictionary.value?[index] = movies
            }
        }
    }
    
    internal func getMoviesForSection(_ index: Int,
                                     _ completion: @escaping ([MovieForCollection]) -> ()) {
        guard let genreId = self.genres.value?[index].id else {
            print("Failed to get genre id for section \(index)")
            return
        }
        let genreIdString = String(genreId)
        
        networkManager?.downloadMoviesByGenre(genreIdString) { data in
            guard let movieArray = data.results else {
                print("It was not possible to get an array of films with the genre \(genreIdString)")
                return
            }
            completion(movieArray)
        }
    }
    
    func numberOfSection() -> Int {
        return genres.value?.count ?? 0
    }
    
    func numberOfItemsIn(_ section: Int) -> Int {
        guard let array = self.moviesDictionary.value?[section] else { return 0 }
        return array.count
    }
    
}
