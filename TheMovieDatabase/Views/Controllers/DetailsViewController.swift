//
//  DetailsViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var testText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Details"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        testLabel.text = testText
        
        view.addSubview(testLabel)
        
        NSLayoutConstraint.activate([
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}
