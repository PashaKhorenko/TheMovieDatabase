//
//  StandartStackView.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 24.01.2023.
//

import UIKit

class StandartStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        axis = .vertical
        spacing = 10
        translatesAutoresizingMaskIntoConstraints = false
    }

}
