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
            testLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            testLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func configure(with text: String) {
        testLabel.text = text
    }
    
}
