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
    
    // MARK: - Settings
    private func makeNavigationBarTransparent() {
        // Some settings
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.tintColor = .label
        
        // Transparency settings
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    private func setupViews() {
        makeNavigationBarTransparent()
        
        self.view.backgroundColor = .systemBackground
        
        self.posterImageView.backgroundColor = .systemGray
        
        generalSubtitleLabel.text = "General Information"
        reactionSubtitleLabel.text = "Reactions"
        overviewSubtitleLabel.text = "Overview"
        
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
//        overviewLabel.text = movie.overview ?? "Unknown"
        overviewLabel.text = String(repeating: "\(movie.overview!)", count: 10)
        
        genresLabel.text = viewModel.getGenreNamesFrom(list: movie.genres)
        ageRestrictionsLabel.text = viewModel.getAgeRestrictions(movie.adult)
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
//                self.mainScrollView.isScrollEnabled = false
                self.posterImageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 150)
                self.view.layoutIfNeeded()
            } completion: { _ in
//                self.mainScrollView.isScrollEnabled = true
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0) {
//                self.mainScrollView.isScrollEnabled = false
                self.posterImageView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewWidth * 1.1)
                self.view.layoutIfNeeded()
            } completion: { _ in
//                self.mainScrollView.isScrollEnabled = true
            }
        }
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
            
            videoCollectionView.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor, constant: 20),
            videoCollectionView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            videoCollectionView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            videoCollectionView.heightAnchor.constraint(equalTo: videoCollectionView.widthAnchor, multiplier: 0.5),
            videoCollectionView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
        ])
    }
}
