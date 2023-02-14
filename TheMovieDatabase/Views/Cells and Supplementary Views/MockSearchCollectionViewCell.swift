//
//  MockSearchCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 14.02.2023.
//

import UIKit

class MockSearchCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI elements
    private let mockPosterView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let mockTitleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let mockOverviewView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    func setupViews() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 15
        
        addSubview(mockPosterView)
        addSubview(mockTitleView)
        addSubview(mockOverviewView)
        
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mockPosterView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mockPosterView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            mockPosterView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mockPosterView.widthAnchor.constraint(equalTo: mockPosterView.heightAnchor, multiplier: 0.65),
            
            mockTitleView.topAnchor.constraint(equalTo: mockPosterView.topAnchor),
            mockTitleView.leadingAnchor.constraint(equalTo: mockPosterView.trailingAnchor, constant: 10),
            mockTitleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mockTitleView.heightAnchor.constraint(equalToConstant: 40),
            
            mockOverviewView.topAnchor.constraint(equalTo: mockTitleView.bottomAnchor, constant: 5),
            mockOverviewView.leadingAnchor.constraint(equalTo: mockPosterView.trailingAnchor, constant: 10),
            mockOverviewView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mockOverviewView.bottomAnchor.constraint(equalTo: mockPosterView.bottomAnchor),
        ])
    }
}
