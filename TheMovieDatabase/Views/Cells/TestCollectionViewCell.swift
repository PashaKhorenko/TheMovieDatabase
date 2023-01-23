//
//  TestCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(testLabel)
        
        backgroundColor = .systemGray
        layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            testLabel.topAnchor.constraint(equalTo: topAnchor),
            testLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            testLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            testLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with text: String) {
        testLabel.text = text
    }
    
}
