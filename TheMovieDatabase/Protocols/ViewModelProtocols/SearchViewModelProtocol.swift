//
//  SearchViewModelProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol SearchViewModelProtocol {
    var networkManeger: SearchNetworkManagerProtocol? { get }
    
    var movies: Dynamic<[SearchMovie]> { get set }
    var isSearching: Dynamic<Bool> { get set }
    var timer: Timer? { get set }
    
    func getValidText(_ searchText: String) -> String
    
    func featchMovies(byText text: String, _ completion: @escaping () -> Void)
    func numberOfItemsInSection() -> Int
    
    func clearTheScreen()
}
