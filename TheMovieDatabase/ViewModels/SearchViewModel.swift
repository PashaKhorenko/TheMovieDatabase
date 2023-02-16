//
//  SearchViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 08.02.2023.
//

import Foundation

protocol SearchViewModelProtocol {
    var networkManeger: SearchNetworkManagerProtocol? { get }
    
    var movies: [SearchMovie] { get set }
    
    func featchMovies(byText text: String, _ completion: @escaping() -> ())
    func numberOfItemsInSection() -> Int
}

class SearchViewModel: SearchViewModelProtocol {
    
    internal let networkManeger: SearchNetworkManagerProtocol?
    
    init(networkManeger: SearchNetworkManagerProtocol?) {
        self.networkManeger = networkManeger
    }
    
    var movies: [SearchMovie] = []
    
    func featchMovies(byText text: String, _ completion: @escaping() -> ()) {
        let validText = text.lowercased().trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "%20")
        
        networkManeger?.seacthMoviesBy(validText) { [weak self] results in
            guard let self, let movieArray = results.results else { return }
            
            self.movies = movieArray
            completion()
        }
    }
    
    func numberOfItemsInSection() -> Int {
        return movies.count
    }
}
