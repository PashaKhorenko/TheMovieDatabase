//
//  FavoritesViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private let viewModel: FavoriteViewModelProtocol?
    
    // MARK: - Init
    init(viewModel: FavoriteViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    private var collectionView: UICollectionView! = nil
    private let favoriteCellID = "FavoriteCell"

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        configureViewModelObserver()
        configureHierarchy()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.featchFavoriteMovies()
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = viewModel?.numberOfItemsInSection() ?? 0
        
        if numberOfItems == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                   width: self.view.bounds.size.width,
                                                   height: self.view.bounds.size.height))
            emptyLabel.text = "The list of favorite movies is empty."
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

// MARK: - UICollectionViewDelegate

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
    
    private func configureViewModelObserver() {
        self.viewModel?.favoriteMovies.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
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
            
            section.visibleItemsInvalidationHandler = { (items, offset, environment) in
                items.forEach { item in
                    let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                    let minScale: CGFloat = 0.9
                    let maxScale: CGFloat = 1
                    let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                    item.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
            
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}
