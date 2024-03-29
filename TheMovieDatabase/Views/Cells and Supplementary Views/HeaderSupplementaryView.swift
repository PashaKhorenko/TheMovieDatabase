//
//  HeaderSupplementaryView.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 23.01.2023.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {
    
    // MARK: - UI elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test Header"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - View lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    // MARK: - Private
    private func setupViews() {
        self.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    // MARK: - Public
    func configure(withText text: String) {
        self.titleLabel.text = text
    }
}
