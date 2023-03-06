//
//  SearchVC+UITableViewDelegate.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 06.03.2023.
//

import UIKit

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Transfer text to search bar when cell is clicked
        let selectedText = self.viewModel?.arrayPreviousSearches.value?[indexPath.row]
        
        DispatchQueue.main.async {
            self.searchController.searchBar.text = selectedText
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
}
