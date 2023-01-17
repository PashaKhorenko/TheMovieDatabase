//
//  FavoritesViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private let detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Details", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        detailsButton.addTarget(self, action: #selector(detailsButtonPressed(_:)), for: .touchUpInside)

        view.addSubview(detailsButton)
        
        NSLayoutConstraint.activate([
            detailsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailsButton.widthAnchor.constraint(equalToConstant: 150),
            detailsButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc func detailsButtonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(DetailsViewController(), animated: true)
    }
}
