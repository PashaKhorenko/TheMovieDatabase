//
//  CompanyCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 06.02.2023.
//

import UIKit

class CompanyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI elements
    private let testLabel = StandartLabel()
    
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
        backgroundColor = .systemGray
        layer.cornerRadius = 15
        clipsToBounds = true
        
        addSubview(testLabel)
        
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public
    func configureWith(_ company: ProductionCompany?) {
        guard let name = company?.name else { return }
        testLabel.text = name
    }
    
}
