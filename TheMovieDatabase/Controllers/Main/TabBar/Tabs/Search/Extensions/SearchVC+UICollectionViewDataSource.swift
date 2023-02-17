//
//  SearchVC+UICollectionViewDataSource.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import UIKit

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let isSearching = self.viewModel?.isSearching.value else { return 0}

        if isSearching {
            return viewModel?.numberOfItemsInSection() ?? 0
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let isSearching = self.viewModel?.isSearching.value else { return UICollectionViewCell()}
        
        if isSearching {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as! SearchCollectionViewCell
            
            guard let movie = viewModel?.movies.value?[indexPath.item] else { return UICollectionViewCell() }
            
            cell.configure(with: movie)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mockCollectionViewCellId, for: indexPath) as! MockSearchCollectionViewCell
            return cell
        }
    }
}
