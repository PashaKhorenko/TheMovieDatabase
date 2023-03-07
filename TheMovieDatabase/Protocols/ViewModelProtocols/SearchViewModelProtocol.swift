//
//  SearchViewModelProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol SearchViewModelProtocol {
    var networkManeger: SearchNetworkManagerProtocol? { get }
    var storageManager: StorageProtocol? { get }
    
    var movies: Dynamic<[SearchMovie]> { get set }
    var previousSearchesArray: Dynamic<[String]> { get set }
    var isSearchBarActive: Dynamic<Bool> { get set }
    var isInSearch: Dynamic<Bool> { get set }
    
    func addNewSearchTextToArray(_ text: String)
    
    func savePreviousSearchsToStorage()
    func getPreviousSearchesArrayFromStarage()
    
    func getValidText(_ searchText: String) -> String
    
    func featchMovies(byText text: String)
    
    func numberOfItemsInCollectionSection() -> Int
    func numberOfItemsInTableSection() -> Int
    
    func clearTheScreen()
}
