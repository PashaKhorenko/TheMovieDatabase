//
//  SearchVC+UISearchBarDelegate.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import UIKit

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.viewModel?.clearTheScreen()
        } else {
            self.viewModel?.featchMovies(byText: searchText) { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel?.clearTheScreen()
    }
}
