//
//  SearchVC+UISearchBarDelegate.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import UIKit

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.viewModel?.isSearchBarActive.value = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel?.isSearchBarActive.value = false
        
        guard let searchText = searchBar.text else { return }
        let validSearchText = searchText.trimmingCharacters(in: .whitespaces)
        guard !validSearchText.isEmpty else { return }
        
        self.viewModel?.featchMovies(byText: validSearchText)
        self.viewModel?.addNewSearchTextToArray(validSearchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel?.clearTheScreen()
    }
}
