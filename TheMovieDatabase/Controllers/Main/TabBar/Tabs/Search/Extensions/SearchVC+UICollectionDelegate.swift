//
//  SearchVC+UICollectionDelegate.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import UIKit

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let isInSearch = self.viewModel?.isInSearch.value else { return }
        guard isInSearch else { return }
        
        guard let id = viewModel?.movies.value?[indexPath.item].id else { return }
        
        let detailsVM = DetailsViewModel(networkManager: DetailsNetworkManager(),
                                         storageManager: StorageManager())
        let detailsVC = DetailsViewController(viewModel: detailsVM)
        detailsVC.movieID = id
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
