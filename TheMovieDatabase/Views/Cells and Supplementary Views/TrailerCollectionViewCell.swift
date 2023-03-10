//
//  TrailerCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 26.01.2023.
//

import UIKit
import youtube_ios_player_helper

class TrailerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI elements
    private let playerView: YTPlayerView = {
        let view = YTPlayerView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
        self.layer.cornerRadius = 15
    }
    
    // MARK: - Private
    private func setupViews() {
        addSubview(playerView)
        playerView.addSubview(activityIndicator)
        
        backgroundColor = .systemGray
        clipsToBounds = true
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: topAnchor),
            playerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public
    func configureWith(_ video: [Video]?, index: Int) {
        self.activityIndicator.startAnimating()
        
        guard let video else { return }
        guard let videoKey = video[index].key else { return }
        
        DispatchQueue.main.async {
            self.playerView.load(withVideoId: videoKey)
        }
    }
}
