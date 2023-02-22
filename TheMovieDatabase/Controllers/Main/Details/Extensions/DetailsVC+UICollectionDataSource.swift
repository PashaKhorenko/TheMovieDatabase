//
//  DetailsVC+UICollectionDataSource.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 22.02.2023.
//

import UIKit

extension DetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItemsIn(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trailetCellID, for: indexPath) as! TrailerCollectionViewCell
            
            cell.configureWith(viewModel?.videoArray.value, index: indexPath.item)
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: companyCellID, for: indexPath) as! CompanyCollectionViewCell
            
            let company = viewModel?.movie.value??.productionCompanies?[indexPath.item]
            cell.configureWith(company)
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderID, for: indexPath) as! HeaderSupplementaryView
        
        switch indexPath.section {
        case 0:
            headerView.configure(withText: "Trailers")
        default:
            headerView.configure(withText: "Production Companies")
        }
        
        return headerView
    }
}
