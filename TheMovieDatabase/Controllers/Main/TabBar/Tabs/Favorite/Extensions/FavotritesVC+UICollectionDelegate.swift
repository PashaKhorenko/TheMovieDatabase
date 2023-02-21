//
//  FavotritesVC+UICollectionDelegate.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 21.02.2023.
//

import UIKit

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVM = DetailsViewModel(networkManager: DetailsNetworkManager(),
                                         storageManager: StorageManager())
        let detailsVC = DetailsViewController(viewModel: detailsVM)
                
        let moviesArray = viewModel?.favoriteMovies.value
        guard let movieID = moviesArray?[indexPath.item].id else { return }
        
        detailsVC.movieID = movieID
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let removeFromFavoriteAction = UIAction(title: "Remove From Favorite",
                                                image: UIImage(systemName: "trash"),
                                                attributes: .destructive) { [weak self] _ in
            guard let self,
                  let indexPath = indexPaths.first,
                  let viewModel = self.viewModel,
                  let movieID = viewModel.favoriteMovies.value?[indexPath.item].id  else { return }
            
            viewModel.removeFromFavorites(movieID: movieID)
        }
        
        let uiMenu = UIMenu(children: [removeFromFavoriteAction])
        let uiContextMenu = UIContextMenuConfiguration(actionProvider:  { _ in
            return uiMenu
        })
        return uiContextMenu
    }
}
