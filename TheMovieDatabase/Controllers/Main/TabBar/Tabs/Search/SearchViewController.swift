//
//  SecondTabViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    let viewModel: SearchViewModelProtocol?
    
    // MARK: - Init
    init(viewModel: SearchViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    let collectionViewCellId = "searchCell"
    let mockCollectionViewCellId = "mockSearchCell"
    
    // MARK: UI elements
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createCollectionLayout())
        collectionView.register(SearchCollectionViewCell.self,
                                forCellWithReuseIdentifier: collectionViewCellId)
        collectionView.register(MockSearchCollectionViewCell.self,
                                forCellWithReuseIdentifier: mockCollectionViewCellId)
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
    let activityIndicator = StandartActivityIndicator(frame: .zero)

    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupViewModelObserver()
    }
}

// MARK: - Setup Views
extension SearchViewController {
    
    private func setupViewModelObserver() {
        self.viewModel?.movies.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        self.viewModel?.isSearching.bind { [weak self] (isSearching) in
            guard let isSearching else { return }
            
            DispatchQueue.main.async {
                if isSearching {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        
        view.addSubview(collectionView)
        collectionView.addSubview(activityIndicator)
        
        setConstraints()
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
