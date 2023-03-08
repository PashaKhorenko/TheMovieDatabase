//
//  SearchViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 08.02.2023.
//

import Foundation

class SearchViewModel: SearchViewModelProtocol {
    
    let networkManeger: SearchNetworkManagerProtocol?
    let storageManager: StorageProtocol?
    
    // MARK: - Init
    init(networkManeger: SearchNetworkManagerProtocol?, storageManager: StorageProtocol?) {
        self.networkManeger = networkManeger
        self.storageManager = storageManager
    }
    
    // MARK: - Properties
    var movies: Dynamic<[SearchMovie]> = Dynamic([])
    var previousSearchesArray: Dynamic<[String]> = Dynamic([])
    
    var isSearchBarActive: Dynamic<Bool> = Dynamic(false)
    var isInSearch: Dynamic<Bool> = Dynamic(false)
     
    // MARK: - Add new search to array
    func addNewSearchTextToArray(_ text: String) {
        guard let array = self.previousSearchesArray.value else { return }
        
        if array.contains(text) {
            guard let currentIndex = array.firstIndex(of: text) else { return }
            self.previousSearchesArray.value?.swapAt(currentIndex, 0)
        } else {
            self.previousSearchesArray.value?.insert(text, at: 0)
        }
        
        self.savePreviousSearchsToStorage()
    }
    
    // MARK: - Delete search from array
    func deletePreviousSearchByIndex(_ index: Int) {
        guard let arrayCount = self.previousSearchesArray.value?.count else { return }
        let reverseIndex = arrayCount - 1 - index
        
        self.previousSearchesArray.value?.remove(at: index)
        self.storageManager?.deletePreviousSearchByIndex(reverseIndex)
    }
    
    // MARK: - Actions with storage
    func savePreviousSearchsToStorage() {
        guard let array = self.previousSearchesArray.value else { return }
        
        for item in array {
            self.storageManager?.savePreviousSearchesToStorage(item)
        }
    }
    
    func getPreviousSearchesArrayFromStarage() {
        let array = self.storageManager?.getPreviousSearchesFromStorage()
        self.previousSearchesArray.value = array
    }
    
    // MARK: - Text validation
    func getValidText(_ searchText: String) -> String {
        let textInLowercase = searchText.lowercased()
        let textWithoutExtraSpaces = textInLowercase.trimmingCharacters(in: .whitespaces)
        let validText = textWithoutExtraSpaces.replacingOccurrences(of: " ", with: "%20")
        
        return validText
    }
    
    // MARK: - Featch movies
    func featchMovies(byText text: String) {
        self.isInSearch.value = true
        
        let validTextForSearching = self.getValidText(text)
        
        guard !validTextForSearching.isEmpty else {
            self.isInSearch.value = false
            return
        }
        
        self.networkManeger?.searchMoviesBy(validTextForSearching) { [weak self] responseModel in
            guard let movieArray = responseModel.results else { return }
            self?.movies.value = movieArray
        }
    }
    
    // MARK: - Number of items
    func numberOfItemsInCollectionSection() -> Int {
        movies.value?.count ?? 0
    }
    
    func numberOfItemsInTableSection() -> Int {
        previousSearchesArray.value?.count ?? 0
    }
    
    // MARK: - Clear the screen
    func clearTheScreen() {
        self.isSearchBarActive.value = false
        self.isInSearch.value = false
        self.movies.value = []
    }
}
