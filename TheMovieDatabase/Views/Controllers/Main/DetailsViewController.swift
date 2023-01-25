//
//  DetailsViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    private let viewModel = DetailsViewModel()
    var movieID: Int = 0
    
    // MARK: - UI elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
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

    // MARK: - Views Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getMovie(withID: movieID) { [weak self] (movie) in
            self?.populateUIFor(movie: movie)
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
//        navigationItem.title = "Details"
        navigationItem.largeTitleDisplayMode = .never
        scrollView.contentInsetAdjustmentBehavior = .never
        
        self.view.backgroundColor = .systemBackground
        self.posterImageView.backgroundColor = .systemGray
        
        generalSubtitleLabel.text = "General Information"
        reactionSubtitleLabel.text = "Reactions"
        overviewSubtitleLabel.text = "Overview"
        
        posterImageView.addSubview(activityIndicator)

        scrollView.addSubview(posterImageView)
        scrollView.addSubview(titleLabel)
        
        generalStackView.addArrangedSubview(generalSubtitleLabel)
        generalStackView.addArrangedSubview(releaseDateLabel)
        generalStackView.addArrangedSubview(genresLabel)
        generalStackView.addArrangedSubview(ageRestrictionsLabel)
        
        scrollView.addSubview(generalStackView)
        
        reactionStackView.addArrangedSubview(reactionSubtitleLabel)
        reactionStackView.addArrangedSubview(popularityLabel)
        
        scrollView.addSubview(reactionStackView)
        
        overviewStackView.addArrangedSubview(overviewSubtitleLabel)
        overviewStackView.addArrangedSubview(overviewLabel)
        
        scrollView.addSubview(overviewStackView)
        
        view.addSubview(scrollView)
        
        setConstraints()
    }
    
    private func populateUIFor(movie: MovieForDetails) {
        titleLabel.text = movie.title
        
        let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath!)")!
        posterImageView.sd_setImage(with: url) { (_, _, _, _) in
            self.activityIndicator.stopAnimating()
        }
        
        releaseDateLabel.text = "Relise date: \(movie.releaseDate!)"
//        genresLabel.text = getMovieGenre(from: movie.genreIDS.convertToArray())

        if movie.adult! {
            ageRestrictionsLabel.text = "Age restrictions: Children are prohibited"
        } else {
            ageRestrictionsLabel.text = "Age restrictions: Missing"
        }
        
        popularityLabel.text = "Popularity: \(movie.popularity!)"
        
        overviewLabel.text = String(repeating: "\(movie.overview!)", count: 5)
    }
    
//    private func getMovieGenre(from movieGenres: [Int]) -> String {
//        var result = "Genre: "
//
//        for movieGenreID in movieGenres {
//            for genre in genresArray {
//                if movieGenreID == genre.id {
//                    result.append("\(genre.name), ")
//                }
//            }
//        }
//
//        return String(result.dropLast(2))
//    }
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

            overviewLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 40)
        ])
    }
}
