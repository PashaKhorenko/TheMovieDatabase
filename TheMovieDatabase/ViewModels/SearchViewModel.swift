//
//  SearchViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 08.02.2023.
//

import Foundation

class SearchViewModel: SearchViewModelProtocol {
    
    internal let networkManeger: SearchNetworkManagerProtocol?
    
    init(networkManeger: SearchNetworkManagerProtocol?) {
        self.networkManeger = networkManeger
    }
    
    var movies: Dynamic<[SearchMovie]> = Dynamic([])
    var isSearching: Dynamic<Bool> = Dynamic(false)
    var timer: Timer?
    
    func getValidText(_ searchText: String) -> String {
        let textInLowercase = searchText.lowercased()
        let textWithoutExtraSpaces = textInLowercase.trimmingCharacters(in: .whitespaces)
        let validText = textWithoutExtraSpaces.replacingOccurrences(of: " ", with: "%20")
        
        return validText
    }
    
    func featchMovies(byText text: String, _ completion: @escaping () -> Void) {
        timer?.invalidate()
        isSearching.value = true
        
        let validText = self.getValidText(text)
        
        guard !validText.isEmpty else {
            self.isSearching.value = false
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.networkManeger?.searchMoviesBy(validText) { [weak self] results in
                guard let self, let movieArray = results.results else { return }
                self.movies.value = movieArray
                completion()
            }
        }
    }
    
    func numberOfItemsInSection() -> Int {
        return movies.value?.count ?? 0
    }
    
    func clearTheScreen() {
        self.isSearching.value = false
        self.movies.value = []
    }
}
