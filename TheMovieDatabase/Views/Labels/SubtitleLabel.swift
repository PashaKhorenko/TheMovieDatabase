//
//  SubtitleLabel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 24.01.2023.
//

import UIKit

class SubtitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        numberOfLines = 2
        font = UIFont(name: "Avenir Next Bold", size: 18)
        translatesAutoresizingMaskIntoConstraints = false
    }

}
