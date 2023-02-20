//
//  HomeVC+CollectionDataSource.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 20.02.2023.
//

import UIKit

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.numberOfSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItemsIn(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCellID, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        
        let moviesArray = self.viewModel?.moviesDictionary.value?[indexPath.section]
        guard let movie = moviesArray?[indexPath.item] else { return UICollectionViewCell() }
        
        cell.configure(forMovie: movie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderID, for: indexPath) as! HeaderSupplementaryView
        
        let title = viewModel?.genres.value?[indexPath.section].name
        headerView.configure(withText: title ?? "Section \(indexPath.section)")
        
        return headerView
    }
}
