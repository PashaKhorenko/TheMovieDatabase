//
//  DetailsViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let viewModel: DetailsViewModelProtocol?
    
    // MARK: - Init
    init(viewModel: DetailsViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    var movieID: Int = 0
    
    var isFavoriteMovie: Bool = false
    
    let trailetCellID = "TrailerCell"
    let companyCellID = "CompanyCell"
    let sectionHeaderID = "SectionHeader"
    
    // MARK: - UI elements
    lazy var mainScrollView: UIScrollView = {
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
    lazy var posterImageView: UIImageView = {
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
        
        getAllData()
        
        configureViewModelObserver()
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    // MARK: - Data binding
    
    private func getAllData() {
        viewModel?.getMovie(withID: movieID)
        viewModel?.getVideo(byMovieID: movieID)
    }
    
    private func configureViewModelObserver() {
        self.viewModel?.movie.bind { [weak self] _ in
            guard let optionalMovie = self?.viewModel?.movie.value else { return }
            guard let movie = optionalMovie else { return }
            
            DispatchQueue.main.async {
                self?.populateUIFor(movie: movie)
            }
        }
        
        self.viewModel?.videoArray.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        self.viewModel?.posterImageData.bind { [weak self] _ in
            guard let optionalData = self?.viewModel?.posterImageData.value,
                  let data = optionalData else { return }
            
            DispatchQueue.main.async {
                self?.posterImageView.image = UIImage(data: data)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Settings
    private func setupViews() {
        configurationNavigationBar()
        self.view.backgroundColor = .systemBackground
        self.posterImageView.backgroundColor = .systemGray
                
        addAllSubviews()
    }
    
    private func configurationNavigationBar() {
        configurationRightBarButtonItem()
        configurationBackBarButtonItem()
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    // MARK: Configuration right bar button
    private func configurationRightBarButtonItem() {
        let imageName = isFavoriteMovie ? "star.fill" : "star"
        let image = UIImage(systemName: imageName)
        
        let customButton = UIButton(type: .system)
        customButton.setImage(image, for: .normal)
        customButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        customButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        customButton.tintColor = .systemBackground
        customButton.layer.cornerRadius = 10
        customButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        
        let customBarButtonItem = UIBarButtonItem(customView: customButton)
        navigationItem.rightBarButtonItem = customBarButtonItem
    }
    
    // Action when right button tapped
    @objc func rightBarButtonTapped(_ sender: UIBarButtonItem) {
        guard let sessionType = self.viewModel?.storageManager?.getSessionType() else { return }
        
        switch sessionType {
        case .guest: self.showAlertAboutGuestSessionLimit()
        case .authorized: self.markAsFavorites()
        }
    }
    
    // Action options when clicking on the button depending on the type of session
    private func showAlertAboutGuestSessionLimit() {
        let message = "You cannot add a movie to your favorites list if you are using the guest version. Sign in or create an account to continue."
        
        let alertController = UIAlertController(title: "Oops...",
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func markAsFavorites() {
        self.viewModel?.markAsFavorites(movieID: self.movieID) { statusBool in
            self.isFavoriteMovie = statusBool
            self.configurationRightBarButtonItem()
        }
    }
    
    // MARK: Configuaretion back bar button
    private func configurationBackBarButtonItem() {
        // Add a UIScreenEdgePanGestureRecognizer to the view
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackSwipe))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)
        
        // Add a custom back button item to the navigation bar
        let customButton = UIButton(type: .system)
        customButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        customButton.setTitleColor(.label, for: .normal)
        customButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        customButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        customButton.tintColor = .systemBackground
        customButton.layer.cornerRadius = 10
        customButton.addTarget(self, action: #selector(backBarButtonTapped(_:)), for: .touchUpInside)
        
        let customBackBarButtomItem = UIBarButtonItem(customView: customButton)
        navigationItem.leftBarButtonItem = customBackBarButtomItem
    }
    
    // Action when back button tapped
    @objc private func backBarButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Action for the right swipe gesture to return to the previous controller
    @objc private func handleBackSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if gestureRecognizer.state == .recognized {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Subview
    private func addSubviewsToGeneralStackView() {
        generalStackView.addArrangedSubview(generalSubtitleLabel)
        generalStackView.addArrangedSubview(releaseDateLabel)
        generalStackView.addArrangedSubview(runtimeLabel)
        generalStackView.addArrangedSubview(genresLabel)
        generalStackView.addArrangedSubview(budgetLabel)
        generalStackView.addArrangedSubview(revenueLabel)
        generalStackView.addArrangedSubview(ageRestrictionsLabel)
        generalStackView.addArrangedSubview(contriesLabel)
    }
    
    private func addSubviewsToReactionStackView() {
        reactionStackView.addArrangedSubview(reactionSubtitleLabel)
        reactionStackView.addArrangedSubview(popularityLabel)
    }
    
    private func addSubviewToOverviewStackView() {
        overviewStackView.addArrangedSubview(overviewSubtitleLabel)
        overviewStackView.addArrangedSubview(overviewLabel)
    }
    
    private func addAllSubviews() {
        posterImageView.addSubview(activityIndicator)
        
        view.addSubview(posterImageView)
        mainScrollView.addSubview(titleLabel)
        
        addSubviewsToGeneralStackView()
        mainScrollView.addSubview(generalStackView)
        
        addSubviewsToReactionStackView()
        mainScrollView.addSubview(reactionStackView)
        
        addSubviewToOverviewStackView()
        mainScrollView.addSubview(overviewStackView)
        
        mainScrollView.addSubview(collectionView)
        
        view.addSubview(mainScrollView)
    }
    
    // MARK: - Filling the UI
    
    private func populateUIFor(movie: MovieForDetails) {
        generalSubtitleLabel.text = "General Information"
        reactionSubtitleLabel.text = "Reactions"
        overviewSubtitleLabel.text = "Overview"
        
        viewModel?.getImage(byPath: movie.posterPath)
        
        titleLabel.text = movie.title
        
        releaseDateLabel.text = viewModel?.convertReleaseDateToString(movie.releaseDate)
        runtimeLabel.text = viewModel?.convertRuntimeToNormalFormat(movie.runtime)
        budgetLabel.text = viewModel?.convertBudgetToString(movie.budget)
        popularityLabel.text = viewModel?.convertPopularityToString(movie.popularity)
        revenueLabel.text = viewModel?.convertRevenueToString(movie.revenue)
        contriesLabel.text = viewModel?.convertCountriesToString(movie.productionCountries)
        overviewLabel.text = movie.overview ?? "Unknown"
        
        genresLabel.text = viewModel?.getGenreNamesFrom(list: movie.genres)
        ageRestrictionsLabel.text = viewModel?.getAgeRestrictions(movie.adult)
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
