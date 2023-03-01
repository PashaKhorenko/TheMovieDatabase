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
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.minimumScaleFactor = 0.7
        label.numberOfLines = 1
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
        layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            posterImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5),
            
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 19),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    // MARK: - Public
    func configure(forMovie movie: MovieForCollection) {
        
        self.activityIndicator.startAnimating()
        self.titleLabel.text = movie.title ?? movie.originalTitle ?? "Unknown"
        
        guard let postenPath = movie.posterPath else {
            print("Failed to get poster path")
            return
        }
        let URLstring = "\(APIConstants.baseImageURL)/\(postenPath)"
        guard let url = URL(string: URLstring) else {
            print("Failure poster image url configuration")
            return
        }
        
        posterImageView.sd_setImage(with: url) { (_, _, _, _) in
            self.activityIndicator.stopAnimating()
        }
    }
}
