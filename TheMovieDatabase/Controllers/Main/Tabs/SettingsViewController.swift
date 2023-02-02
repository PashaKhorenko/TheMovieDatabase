//
//  SettingsViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 19.01.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let viewModel = SettingsViewModel()
    
    // MARK: - UI elements
    private lazy var signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemIndigo
        button.addTarget(self, action: #selector(signOutButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.printAccountDetails()
        
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(signOutButton)
        
        setConstraints()
    }
    
    @objc private func signOutButtonTapped(_ sender: UIButton) {
        viewModel.signOutOfTheAccount()
    }
}

// MARK: - Constraints
extension SettingsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
