//
//  HomeVC+CollectionDelegate.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 20.02.2023.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVM = DetailsViewModel(networkManager: DetailsNetworkManager(),
                                         storageManager: StorageManager())
        let detailsVC = DetailsViewController(viewModel: detailsVM)
        
        let moviesArray = self.viewModel?.moviesDictionary.value?[indexPath.section]
        guard let movie = moviesArray?[indexPath.item],
              let movieID = movie.id else { return }
        
        detailsVC.movieID = movieID
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
