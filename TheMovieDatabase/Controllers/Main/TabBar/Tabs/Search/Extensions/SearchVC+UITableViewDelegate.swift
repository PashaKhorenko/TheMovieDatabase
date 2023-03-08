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
        let selectedText = self.viewModel?.previousSearchesArray.value?[indexPath.row]
        
        DispatchQueue.main.async {
            self.searchController.searchBar.text = selectedText
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completion) in
            
            // Delete content from data
            self.viewModel?.deletePreviousSearchByIndex(indexPath.row)
            
            // Delete the cell at the index path
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Call the completion handler to indicate that the action was performed
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
