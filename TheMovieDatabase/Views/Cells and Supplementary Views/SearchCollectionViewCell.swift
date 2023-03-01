//
//  SearchCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 08.02.2023.
//

import UIKit
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI elements
    private let activityIndicator = StandartActivityIndicator(frame: .zero)
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel = SubtitleLabel()
    private let overviewLabel = StandartLabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func configure(with movie: SearchMovie) {
        guard let posterPath = movie.posterPath,
              let titlet = movie.title,
              let overview = movie.overview else { return }
        
        let urlString = "\(APIConstants.baseImageURL)/\(posterPath)"
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.main.async {
            self.posterImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
                self?.activityIndicator.stopAnimating()
            }
            self.titleLabel.text = titlet
            self.overviewLabel.text = overview
        }
    }
    
    // MARK: - Private
    func setupViews() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 15
        
        posterImageView.addSubview(activityIndicator)
        addSubview(posterImageView)
        addSubview(titleLabel)
        addSubview(overviewLabel)
        
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 0.65),
            
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            overviewLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            overviewLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),
        ])
    }
}
