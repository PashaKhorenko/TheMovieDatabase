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
    
    // MARK: - UI elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let generalStackView = StandartStackView()
    private let reactionStackView = StandartStackView()
    private let overviewStackView = StandartStackView()
    
    private var activityIndicator = StandartActivityIndicator(frame: .zero)
    private var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var titleLabel = TitleLabel()
    
    private var generalSubtitleLabel = SubtitleLabel()
    private var releaseDateLabel = StandartLabel()
    private var genresLabel = StandartLabel()
    private var ageRestrictionsLabel = StandartLabel()
    
    private var reactionSubtitleLabel = SubtitleLabel()
    private var popularityLabel = StandartLabel()
    
    private var overviewSubtitleLabel = SubtitleLabel()
    private var overviewLabel = StandartLabel()
    
    private let backgroundForBlurImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let videoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .red
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    

    // MARK: - Views Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getMovie(withID: movieID) { [weak self] (movie) in
            self?.populateUIFor(movie: movie)
        }
        viewModel.getVideo(byMovieID: movieID) {
            print("Video downloaded")
        }
        
        setupViews()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        var insets = view.safeAreaInsets
        insets.top = 0
        scrollView.contentInset = insets
    }
    
    // MARK: - Settings
    private func setupViews() {
        navigationItem.largeTitleDisplayMode = .never
        scrollView.contentInsetAdjustmentBehavior = .never
        
        self.view.backgroundColor = .systemBackground
        self.navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2901960784, green: 0.4235294118, blue: 0.8196078431, alpha: 1)
        self.posterImageView.backgroundColor = .systemGray
        
        generalSubtitleLabel.text = "General Information"
        reactionSubtitleLabel.text = "Reactions"
        overviewSubtitleLabel.text = "Overview"
        
        posterImageView.addSubview(activityIndicator)

        scrollView.addSubview(posterImageView)
        
        backgroundForBlurImageView.addSubview(blurView)
        scrollView.addSubview(backgroundForBlurImageView)
        
        blurView.contentView.addSubview(titleLabel)
        
        generalStackView.addArrangedSubview(generalSubtitleLabel)
        generalStackView.addArrangedSubview(releaseDateLabel)
        generalStackView.addArrangedSubview(genresLabel)
        generalStackView.addArrangedSubview(ageRestrictionsLabel)

        blurView.contentView.addSubview(generalStackView)

        reactionStackView.addArrangedSubview(reactionSubtitleLabel)
        reactionStackView.addArrangedSubview(popularityLabel)

        blurView.contentView.addSubview(reactionStackView)

        overviewStackView.addArrangedSubview(overviewSubtitleLabel)
        overviewStackView.addArrangedSubview(overviewLabel)
        
        blurView.contentView.addSubview(overviewStackView)
        
        blurView.contentView.addSubview(videoCollectionView)
        
        view.addSubview(scrollView)
        
        setConstraints()
    }
    
    private func populateUIFor(movie: MovieForDetails) {
        viewModel.getImage(byPath: movie.posterPath) { [weak self] imageData in
            guard let self else { return }
            
            self.posterImageView.image = UIImage(data: imageData)
            self.backgroundForBlurImageView.image = UIImage(data: imageData)
            
            self.activityIndicator.stopAnimating()
        }
        
        titleLabel.text = movie.title
        
        releaseDateLabel.text = "Relise date: \(movie.releaseDate ?? "Unknown")"
        popularityLabel.text = "Popularity: \(movie.popularity ?? 0.0)"
        overviewLabel.text = movie.overview ?? "Unknown"
//        overviewLabel.text = String(repeating: "\(movie.overview!)", count: 55)
        
        genresLabel.text = viewModel.getGenreNamesFrom(list: movie.genres)
        ageRestrictionsLabel.text = viewModel.getAgeRestrictions(movie.adult)
    }
}

// MARK: - Constraints

extension DetailsViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            
            backgroundForBlurImageView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            backgroundForBlurImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            backgroundForBlurImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            backgroundForBlurImageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            blurView.topAnchor.constraint(equalTo: backgroundForBlurImageView.topAnchor, constant: -25),
            blurView.leadingAnchor.constraint(equalTo: backgroundForBlurImageView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: backgroundForBlurImageView.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: backgroundForBlurImageView.bottomAnchor, constant: 25),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),

            generalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            generalStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            generalStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),

            reactionStackView.topAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: 20),
            reactionStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            reactionStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),

            overviewStackView.topAnchor.constraint(equalTo: reactionStackView.bottomAnchor, constant: 20),
            overviewStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            overviewStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            overviewStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            overviewLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            
            videoCollectionView.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor, constant: 20),
            videoCollectionView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
            videoCollectionView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor),
            videoCollectionView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor)
        ])
    }
}
