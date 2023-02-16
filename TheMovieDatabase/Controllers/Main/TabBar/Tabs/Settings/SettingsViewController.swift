//
//  SettingsViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 19.01.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let viewModel = SettingsViewModel(storageManeger: StorageManager())
    
    // MARK: - UI elements
    private var accountInfoView = AccountInfoView()
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

       setupViews()
    }
    
    // MARK: - Private
    @objc private func signOutButtonTapped(_ sender: UIButton) {
        viewModel.signOutOfTheAccount()
    }
    
    // MARK: settings
    private func configureAccountInfoView() {
        guard let accountDetails = viewModel.getAccountDetails() else { return }
        accountInfoView.configure(with: accountDetails)
    }
    
    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(accountInfoView)
        view.addSubview(signOutButton)
        
        configureAccountInfoView()
        
        setConstraints()
    }
    
}

// MARK: - Constraints
extension SettingsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            accountInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            accountInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            accountInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            accountInfoView.heightAnchor.constraint(equalToConstant: 100),
            
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
