//
//  SecondTabViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let massegeLabel: UILabel = {
        let label = UILabel()
        label.text = "The search screen is an optional task."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(massegeLabel)
        
        NSLayoutConstraint.activate([
            massegeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            massegeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
