//
//  SearchVC+UITableViewDataSource.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 06.03.2023.
//

import UIKit

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.numberOfItemsInTableSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableViewCellID, for: indexPath)
        
        guard let searchText = self.viewModel?.arrayPreviousSearches.value?[indexPath.row] else { return UITableViewCell() }
        
        cell.textLabel?.text = searchText
        
        return cell
    }
    
    
}
