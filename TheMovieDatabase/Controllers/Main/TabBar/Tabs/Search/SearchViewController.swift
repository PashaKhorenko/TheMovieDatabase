//
//  SecondTabViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let viewModel = SearchViewModel()
    private let collectionViewCellId = "searchCell"
    
    private var timer: Timer? = nil
    
    // MARK: - UI elements
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createCollectionLayout())
        collectionView.register(SearchCollectionViewCell.self,
                                forCellWithReuseIdentifier: collectionViewCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        return searchController
    }()
    private let activityIndicator = StandartActivityIndicator(frame: .zero)

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
}

// MARK: - setupViews
extension SearchViewController {
    
    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        
        view.addSubview(collectionView)
        collectionView.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
        
        setConstraints()
    }
    
    private func clearTheScreen() {
        self.viewModel.movies = []
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as! SearchCollectionViewCell
        
        let movie = viewModel.movies[indexPath.item]
        cell.configure(with: movie)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = viewModel.movies[indexPath.item].id else { return }
        
        let vc = DetailsViewController()
        vc.movieID = id
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.activityIndicator.startAnimating()

        if searchText == "" {
            
            self.clearTheScreen()
            self.activityIndicator.stopAnimating()
            self.timer?.invalidate()
            
        } else {
            self.clearTheScreen()
            
            // destroy the previously started timer
            self.timer?.invalidate()
            
            // execute a request for movies one second after entering the symbol
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                              repeats: false) { [weak self] _ in
                self?.viewModel.featchMovies(byText: searchText) { [weak self] in
                    guard let self else { return }
                    
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.clearTheScreen()
        self.activityIndicator.stopAnimating()
        searchBar.text = ""
        self.timer?.invalidate()
    }
}

// MARK: - Constraints
extension SearchViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
