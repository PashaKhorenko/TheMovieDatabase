//
//  DetailsViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let viewModel = DetailsViewModel()
    var movieID: Int = 0
    
    private var isFavoriteMovie: Bool = false
    
    private let trailetCellID = "TrailerCell"
    private let companyCellID = "CompanyCell"
    private let sectionHeaderID = "SectionHeader"
    
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
    private let runtimeLabel = StandartLabel()
    private let genresLabel = StandartLabel()
    private let budgetLabel = StandartLabel()
    private let ageRestrictionsLabel = StandartLabel()
    private let contriesLabel = StandartLabel()
    
    private let reactionSubtitleLabel = SubtitleLabel()
    private let revenueLabel = StandartLabel()
    private let popularityLabel = StandartLabel()
    
    private let overviewSubtitleLabel = SubtitleLabel()
    private let overviewLabel = StandartLabel()
    
    private let trailersSubtitleLabel = SubtitleLabel()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createCollectionLayout())
        collectionView.register(TrailerCollectionViewCell.self, forCellWithReuseIdentifier: trailetCellID)
        collectionView.register(CompanyCollectionViewCell.self, forCellWithReuseIdentifier: companyCellID)
        collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderID)
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getMovie(withID: movieID) { [weak self] (movie) in
            DispatchQueue.main.async {
                self?.populateUIFor(movie: movie)
            }
        }
        viewModel.getVideo(byMovieID: movieID) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Transparency settings for nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the nav bar to default
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    
    // MARK: - Settings
    @objc func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.markAsFavorites(movieID: self.movieID) { statusBool in
            self.isFavoriteMovie = statusBool
            self.configurationRightBarButtonItem()
        }
    }
    
    private func configurationRightBarButtonItem() {
        let imageName = isFavoriteMovie ? "star.fill" : "star"
        let image = UIImage(systemName: imageName)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: image, target: self, action: #selector(rightBarButtonTapped(_:)))
    }
    
    private func configurationNavigationBar() {
        // Some settings
        configurationRightBarButtonItem()
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.tintColor = .label
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
        generalStackView.addArrangedSubview(runtimeLabel)
        generalStackView.addArrangedSubview(genresLabel)
        generalStackView.addArrangedSubview(budgetLabel)
        generalStackView.addArrangedSubview(revenueLabel)
        generalStackView.addArrangedSubview(ageRestrictionsLabel)
        generalStackView.addArrangedSubview(contriesLabel)
        
        mainScrollView.addSubview(generalStackView)
        
        reactionStackView.addArrangedSubview(reactionSubtitleLabel)
        reactionStackView.addArrangedSubview(popularityLabel)
        
        mainScrollView.addSubview(reactionStackView)
        
        overviewStackView.addArrangedSubview(overviewSubtitleLabel)
        overviewStackView.addArrangedSubview(overviewLabel)
        
        mainScrollView.addSubview(overviewStackView)
        mainScrollView.addSubview(collectionView)
        
        view.addSubview(mainScrollView)
        
        setConstraints()
    }
    
    private func populateUIFor(movie: MovieForDetails) {
        generalSubtitleLabel.text = "General Information"
        reactionSubtitleLabel.text = "Reactions"
        overviewSubtitleLabel.text = "Overview"
        
        viewModel.getImage(byPath: movie.posterPath) { [weak self] imageData in
            guard let self else { return }
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: imageData)
                self.activityIndicator.stopAnimating()
            }
        }
        
        titleLabel.text = movie.title
        
        releaseDateLabel.text = viewModel.convertReleaseDateToString(movie.releaseDate)
        runtimeLabel.text = viewModel.convertRuntimeToNormalFormat(movie.runtime)
        budgetLabel.text = viewModel.convertBudgetToString(movie.budget)
        popularityLabel.text = viewModel.convertPopularityToString(movie.popularity)
        revenueLabel.text = viewModel.convertRevenueToString(movie.revenue)
        contriesLabel.text = viewModel.convertCountriesToString(movie.productionCountries)
        overviewLabel.text = movie.overview ?? "Unknown"
        
        genresLabel.text = viewModel.getGenreNamesFrom(list: movie.genres)
        ageRestrictionsLabel.text = viewModel.getAgeRestrictions(movie.adult)
    }
}

// MARK: - UICollectionViewDataSource
extension DetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsIn(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trailetCellID, for: indexPath) as! TrailerCollectionViewCell
            
            cell.configureWith(viewModel.videoArray, index: indexPath.item)
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: companyCellID, for: indexPath) as! CompanyCollectionViewCell
            
            let company = viewModel.movie?.productionCompanies?[indexPath.item]
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

// MARK: - UIScrollViewDelegate
extension DetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.mainScrollView else { return }
        
        let viewWidth = self.view.bounds.width
        let initialImageHeight = viewWidth * 1.1
        let scrollPositionY = initialImageHeight + (scrollView.contentOffset.y - initialImageHeight)
                        
        if scrollPositionY > 0 {
            UIView.animate(withDuration: 0.3) {
                self.posterImageView.frame = CGRect(x: 0, y: 0,
                                                    width: viewWidth, height: 150)
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.posterImageView.frame = CGRect(x: 0, y: 0,
                                                    width: viewWidth, height: initialImageHeight)
                self.view.layoutIfNeeded()
            }
        }
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
            
            collectionView.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1.1),
            collectionView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -30),
        ])
    }
}
