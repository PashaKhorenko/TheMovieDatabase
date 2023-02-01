//
//  FavoritesViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private let viewModel = FavoriteViewModel()
    
    private var collectionView: UICollectionView! = nil
    private let favoriteCellID = "FavoriteCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        configureHierarchy()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.featchFavoriteMovies {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.favoriteCellID, for: indexPath) as? FavoriteMovieCollectionViewCell else { return UICollectionViewCell() }
        
        guard let movie = viewModel.favoriteMovies?.results?[indexPath.item] else { return UICollectionViewCell() }
        
        cell.configure(forMovie: movie)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController()
                
        let moviesArray = viewModel.favoriteMovies?.results
        guard let movieID = moviesArray?[indexPath.item].id else { return }
        
        vc.movieID = movieID
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Configuration

extension FavoritesViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(FavoriteMovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: self.favoriteCellID)
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - Layout

extension FavoritesViewController {
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
                                 layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(0.7))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.interGroupSpacing = 5
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
            
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.scrollDirection = .vertical
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}

