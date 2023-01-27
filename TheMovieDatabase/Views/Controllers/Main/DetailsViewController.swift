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
    
    private let itemsPerRow: CGFloat = 1
    private let sectionInserts = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    // MARK: - UI elements
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let generalStackView = StandartStackView()
    private let reactionStackView = StandartStackView()
    private let overviewStackView = StandartStackView()
    
    private var activityIndicator = StandartActivityIndicator(frame: .zero)
    private var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
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
    
    private lazy var videoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCell")
        collectionView.dataSource = self
        collectionView.delegate = self
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
            self.videoCollectionView.reloadData()
        }
        
        setupViews()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        var insets = view.safeAreaInsets
        insets.top = 0
        mainScrollView.contentInset = insets
    }
    
    // MARK: - Settings
    private func setupViews() {
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2901960784, green: 0.4235294118, blue: 0.8196078431, alpha: 1)
        self.posterImageView.backgroundColor = .systemGray
        
        generalSubtitleLabel.text = "General Information"
        reactionSubtitleLabel.text = "Reactions"
        overviewSubtitleLabel.text = "Overview"
        
        posterImageView.addSubview(activityIndicator)

        mainScrollView.addSubview(posterImageView)
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
        
        mainScrollView.addSubview(videoCollectionView)
        
        view.addSubview(mainScrollView)
        
        setConstraints()
    }
    
    private func populateUIFor(movie: MovieForDetails) {
        viewModel.getImage(byPath: movie.posterPath) { [weak self] imageData in
            guard let self else { return }
            self.posterImageView.image = UIImage(data: imageData)
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

//MARK: - UICollectionViewDelegateFlowLayout
extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    
    // Сell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        
        let widthPerItem = availableWidth / itemsPerRow
        let heigthPerItem = widthPerItem * 1.5
        
        return CGSize(width: widthPerItem, height: heigthPerItem)
    }
    
    // Indent the section outward
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    // Indentation within a section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.top
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.top
    }
}

// MARK: - Constraints

extension DetailsViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 15),
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
            
            videoCollectionView.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor, constant: 20),
            videoCollectionView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            videoCollectionView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            videoCollectionView.heightAnchor.constraint(equalTo: videoCollectionView.widthAnchor, multiplier: 0.5),
            videoCollectionView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
        ])
    }
}
