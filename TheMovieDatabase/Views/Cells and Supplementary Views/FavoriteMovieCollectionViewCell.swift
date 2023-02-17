//
//  FavoriteMovieCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 01.02.2023.
//

import UIKit
import SDWebImage

class FavoriteMovieCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI elements
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator = StandartActivityIndicator(frame: .zero)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setupViews() {
        posterImageView.addSubview(activityIndicator)
        addSubview(posterImageView)
        addSubview(titleLabel)
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 25
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            posterImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8),
            
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Public
    func configure(forMovie movie: FavoriteMovie) {
        
        self.activityIndicator.startAnimating()
        self.titleLabel.text = movie.title ?? movie.originalTitle ?? "Unknown"
        
        guard let posterPath = movie.posterPath else {
            print("Failed to get poster path")
            return
        }
        let URLstring = "https://image.tmdb.org/t/p/w500/\(posterPath)"
        guard let url = URL(string: URLstring) else {
            print("Failure poster image url configuration")
            return
        }
        
        posterImageView.sd_setImage(with: url) { (_, _, _, _) in
            self.activityIndicator.stopAnimating()
        }        
    }
}
