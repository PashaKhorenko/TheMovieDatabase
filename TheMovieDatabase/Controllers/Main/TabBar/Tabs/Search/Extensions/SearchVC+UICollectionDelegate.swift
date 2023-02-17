//
//  SearchVC+UICollectionDelegate.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import UIKit

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let isSearching = self.viewModel?.isSearching.value else { return }
        guard isSearching else { return }
        
        guard let id = viewModel?.movies.value?[indexPath.item].id else { return }
        
        let detailsVM = DetailsViewModel(networkManager: DetailsNetworkManager(),
                                         storageManager: StorageManager())
        let detailsVC = DetailsViewController(viewModel: detailsVM)
        detailsVC.movieID = id
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
