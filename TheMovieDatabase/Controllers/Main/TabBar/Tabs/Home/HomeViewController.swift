//
//  HomeViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 16.01.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModelProtocol?
     
    // MARK: - Init
    init(viewModel: HomeViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    private var collectionView: UICollectionView! = nil
    private let movieCellID = "MovieCellID"
    private let sectionHeaderID = "SectionHeaderID"
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModelObserver()
        getAllData()
        
        configureHierarchy()
        configureDataSource()
    }
    
    // MARK: - Data
    private func getAllData() {
        self.viewModel?.getGenres {
            self.viewModel?.getMovies()
        }
    }
}


// MARK: - UICollectionViewDataSource

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

// MARK: - UICollectionViewDelegate

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

// MARK: - Configuration

extension HomeViewController {
    private func configureHierarchy() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: movieCellID)
        collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderID)
        
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
        self.viewModel?.genres.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        self.viewModel?.moviesDictionary.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}
