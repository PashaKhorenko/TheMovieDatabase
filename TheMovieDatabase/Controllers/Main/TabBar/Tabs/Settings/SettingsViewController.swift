//
//  SettingsViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 19.01.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private let viewModel: SettingsViewModelProtocol?
    private var sessionType: SessionType?
    
    // MARK: - Init
    init(viewModel: SettingsViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    private lazy var activityIndicator = StandartActivityIndicator(frame: .zero)

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sessionType = self.viewModel?.getSessionType()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.stopAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    // MARK: - Private
    @objc private func signOutButtonTapped(_ sender: UIButton) {
        self.activityIndicator.startAnimating()
        
        guard let sessionType else {
            self.activityIndicator.stopAnimating()
            return
        }
                
        switch sessionType {
        case .guest:
            self.activityIndicator.stopAnimating()
            self.viewModel?.signOutOfTheAccount()
        case .authorized:
            self.viewModel?.deleteCurrentSessionID { [weak self] _ in
                self?.activityIndicator.stopAnimating()
                self?.viewModel?.signOutOfTheAccount()
            }
        }
    }
    
    // MARK: settings
    private func configureAccountInfoView() {
        guard let accountDetails = viewModel?.getAccountDetails() else { return }
        accountInfoView.configure(with: accountDetails)
    }
    
    private func setupViews() {
        view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if self.sessionType == .authorized {
            view.addSubview(accountInfoView)
        }
        view.addSubview(signOutButton)
        view.addSubview(activityIndicator)
        
        configureAccountInfoView()
    }
}

// MARK: - Constraints
extension SettingsViewController {
    private func setConstraints() {
        
        if self.sessionType == .authorized {
            NSLayoutConstraint.activate([
                accountInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
                accountInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                accountInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                accountInfoView.heightAnchor.constraint(equalToConstant: 100),
            ])
        }
        
        NSLayoutConstraint.activate([
            signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
