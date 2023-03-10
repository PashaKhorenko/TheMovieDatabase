//
//  HomeViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 16.01.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    let viewModel: HomeViewModelProtocol?
     
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
    let movieCellID = "MovieCellID"
    let sectionHeaderID = "SectionHeaderID"
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModelObserver()
        self.viewModel?.getGenres()
        
        configureHierarchy()
        configureDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setConstraints()
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
    }
    
    private func configureDataSource() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureViewModelObserver() {
        
        self.viewModel?.genres.bind { [weak self] _ in
            self?.viewModel?.getMovies()
        }
        
        self.viewModel?.moviesDictionary.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
