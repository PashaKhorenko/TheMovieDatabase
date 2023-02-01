//
//  DetailsViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit
import RealmSwift

class DetailsViewController: UIViewController {
    
    private let realm = try! Realm()
    private let viewModel = DetailsViewModel()
    var movieID: Int = 0
    
    private var accountDetails: Results<AccountDetailsRealm>!
    private var sessionID: Results<SessionIDRealm>!
    
    var isFavouriteMovie: Bool = false
    
    // MARK: - UI elements
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.layer.cornerRadius = 30
        scrollView.delegate = self
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let generalStackView = StandartStackView()
    private let reactionStackView = StandartStackView()
    private let overviewStackView = StandartStackView()
    
    private let activityIndicator = StandartActivityIndicator(frame: .zero)
    private lazy var posterImageView: UIImageView = {
        let viewWidth = self.view.bounds.width
        let frame = CGRect(x: 0, y: 0,
                           width: viewWidth,
                           height: viewWidth * 1.1)
        let imageView = UIImageView(frame: frame)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4
        return imageView
    }()
    
    private var titleLabel = TitleLabel()
    
    private let generalSubtitleLabel = SubtitleLabel()
    private let releaseDateLabel = StandartLabel()
    private let genresLabel = StandartLabel()
    private let ageRestrictionsLabel = StandartLabel()
    
    private let reactionSubtitleLabel = SubtitleLabel()
    private let popularityLabel = StandartLabel()
    
    private let overviewSubtitleLabel = SubtitleLabel()
    private let overviewLabel = StandartLabel()
    
    private let trailersSubtitleLabel = SubtitleLabel()
    private lazy var trailersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createLayout())
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCell")
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Views Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountDetails = realm.objects(AccountDetailsRealm.self)
        sessionID = realm.objects(SessionIDRealm.self)
        
        viewModel.getMovie(withID: movieID) { [weak self] (movie) in
            DispatchQueue.main.async {
                self?.populateUIFor(movie: movie)
            }
        }
        viewModel.getVideo(byMovieID: movieID) {
            DispatchQueue.main.async {
                self.trailersCollectionView.reloadData()
            }
        }
        
        setupViews()
    }
    
    @objc func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        print(#function)
        
        guard let accountID = accountDetails.first?.id,
              let sessionID = sessionID.first?.id else { return }
        
        viewModel.markAsFavourites(accountID: accountID,
                                   sessionID: sessionID,
                                   movieID: self.movieID,
                                   status: !isFavouriteMovie) { statusBool in
            self.isFavouriteMovie = statusBool
            self.configurationRightBarButtonItem()
        }
    }
    
    // MARK: - Settings
    private func configurationRightBarButtonItem() {
        let imageName = isFavouriteMovie ? "star.fill" : "star"
        let image = UIImage(systemName: imageName)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: image, target: self, action: #selector(rightBarButtonTapped(_:)))
    }
    
    private func configurationNavigationBar() {
        // Some settings
        configurationRightBarButtonItem()
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.tintColor = .label
        
        // Transparency settings
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    private func setupViews() {
        configurationNavigationBar()
        
        self.view.backgroundColor = .systemBackground
        
        self.posterImageView.backgroundColor = .systemGray
                
        posterImageView.addSubview(activityIndicator)
        
        view.addSubview(posterImageView)
        mainScrollView.addSubview(titleLabel)
        
        generalStackView.addArrangedSubview(generalSubtitleLabel)
        generalStackView.addArrangedSubview(releaseDateLabel)
        generalStackView.addArrangedSubview(genresLabel)
        generalStackView.addArrangedSubview(ageRestrictionsLabel)
        
        mainScrollView.addSubview(generalStackView)
        
        reactionStackView.addArrangedSubview(reactionSubtitleLabel)
        reactionStackView.addArrangedSubview(popularityLabel)
        
        mainScrollView.addSubview(reactionStackView)
        
        overviewStackView.addArrangedSubview(overviewSubtitleLabel)
        overviewStackView.addArrangedSubview(overviewLabel)
        
        mainScrollView.addSubview(overviewStackView)
        
        mainScrollView.addSubview(trailersSubtitleLabel)
        mainScrollView.addSubview(trailersCollectionView)
        
        view.addSubview(mainScrollView)
        
        setConstraints()
    }
    
    private func populateUIFor(movie: MovieForDetails) {
        generalSubtitleLabel.text = "General Information"
        reactionSubtitleLabel.text = "Reactions"
        overviewSubtitleLabel.text = "Overview"
        trailersSubtitleLabel.text = "Trailers and stills"
        
        viewModel.getImage(byPath: movie.posterPath) { [weak self] imageData in
            guard let self else { return }
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: imageData)
                self.activityIndicator.stopAnimating()
            }
        }
        
        titleLabel.text = movie.title
        
        releaseDateLabel.text = "Relise date: \(movie.releaseDate ?? "Unknown")"
        popularityLabel.text = "Popularity: \(movie.popularity ?? 0.0)"
        overviewLabel.text = movie.overview ?? "Unknown"
//        overviewLabel.text = String(repeating: "\(movie.overview!)", count: 10)
        
        genresLabel.text = viewModel.getGenreNamesFrom(list: movie.genres)
        ageRestrictionsLabel.text = viewModel.getAgeRestrictions(movie.adult)
    }
}

// MARK: - UICollectionViewDataSource
extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCollectionViewCell
        
        cell.configureWith(viewModel.videoArray, index: indexPath.item)
        
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension DetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.mainScrollView else { return }
        
        let viewWidth = self.view.bounds.width
        let imageHeigth = viewWidth * 1.1
        let y = imageHeigth + (scrollView.contentOffset.y - imageHeigth)
        
        var heigth: CGFloat = 0
        
        if y < 0 {
            heigth = imageHeigth + (-y)
        } else {
            heigth = max(150, imageHeigth - y)
        }
        
        if heigth < imageHeigth {
            UIView.animate(withDuration: 0.3) {
                self.posterImageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 150)
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.posterImageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewWidth * 1.1)
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - Layout for collection view

extension DetailsViewController {
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
                                 layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                                   heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.interGroupSpacing = 8
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}

// MARK: - Constraints

extension DetailsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            
            mainScrollView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -30),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: mainScrollView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -20),
            
            generalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            generalStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 20),
            generalStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -20),
            
            reactionStackView.topAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: 20),
            reactionStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 20),
            reactionStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -20),
            
            overviewStackView.topAnchor.constraint(equalTo: reactionStackView.bottomAnchor, constant: 20),
            overviewStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 20),
            overviewStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -20),
            
            overviewLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            
            trailersSubtitleLabel.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor, constant: 20),
            trailersSubtitleLabel.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: 20),
            trailersSubtitleLabel.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -20),
            
            trailersCollectionView.topAnchor.constraint(equalTo: trailersSubtitleLabel.bottomAnchor, constant: 10),
            trailersCollectionView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            trailersCollectionView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            trailersCollectionView.heightAnchor.constraint(equalTo: trailersCollectionView.widthAnchor, multiplier: 0.5),
            trailersCollectionView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -30),
        ])
    }
}
