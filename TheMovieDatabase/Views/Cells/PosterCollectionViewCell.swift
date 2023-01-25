//
//  PosterCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit
import SDWebImage

class PosterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI elements
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        addSubview(posterImageView)
        posterImageView.addSubview(activityIndicator)
        
        backgroundColor = .systemGray
        layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public
    func configure(forMovie movie: MovieForCollection) {
        self.activityIndicator.startAnimating()
        
        guard let postenPath = movie.posterPath else {
            print("Failed to get poster path")
            return
        }
        let URLstring = "https://image.tmdb.org/t/p/w500/\(postenPath)"
        guard let url = URL(string: URLstring) else {
            print("Failure poster image url configuration")
            return
        }
        
        posterImageView.sd_setImage(with: url) { (_, _, _, _) in
            self.activityIndicator.stopAnimating()
        }
    }
}
