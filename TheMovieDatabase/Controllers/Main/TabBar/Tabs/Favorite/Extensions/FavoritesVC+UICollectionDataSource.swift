//
//  FavoritesVC+UICollectionDataSource.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 21.02.2023.
//

import UIKit

extension FavoritesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = viewModel?.numberOfItemsInSection() ?? 0
        let message = viewModel?.getMessagesDependingOnTheSessionType()
        
        if numberOfItems == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                   width: self.view.bounds.size.width,
                                                   height: self.view.bounds.size.height))
            emptyLabel.text = message
            emptyLabel.numberOfLines = 0
            emptyLabel.textAlignment = NSTextAlignment.center
            collectionView.backgroundView = emptyLabel
            return 0
        } else {
            collectionView.backgroundView = nil
            return numberOfItems
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.favoriteCellID, for: indexPath) as? FavoriteMovieCollectionViewCell else { return UICollectionViewCell() }
        
        guard let movie = viewModel?.favoriteMovies.value?[indexPath.item] else { return UICollectionViewCell() }
        
        cell.configure(forMovie: movie)
        
        return cell
    }
}
