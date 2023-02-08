//
//  SearchVC+createCollectionLayout.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 08.02.2023.
//

import UIKit

extension SearchViewController {
    func createCollectionLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
                                 layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            // item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(180))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            // section
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 15
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 15,
                                                            bottom: 10,
                                                            trailing: 15)
            
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}
