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
    let tableViewCellID = "tableViewCellID"
    
    // MARK: UI elements
    lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        return searchController
    }()
    lazy var collectionView: UICollectionView = {
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
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.tableViewCellID)
        tableView.backgroundColor = .secondarySystemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
                self?.activityIndicator.stopAnimating()
            }
        }
        
        self.viewModel?.arrayPreviousSearches.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        self.viewModel?.isSearchBarActive.bind { [weak self] (isSearchBarActive) in
            guard let isSearchBarActive else { return }
            
            if isSearchBarActive {
                self?.collectionView.isHidden = true
                self?.tableView.isHidden = false
            } else {
                self?.collectionView.isHidden = false
                self?.tableView.isHidden = true
            }
        }
        
        self.viewModel?.isInSearch.bind { [weak self] (isInSearch) in
            guard let isInSearch else { return }
            
            if isInSearch {
                self?.activityIndicator.startAnimating()
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        
        view.addSubview(collectionView)
        view.addSubview(tableView)
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
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
