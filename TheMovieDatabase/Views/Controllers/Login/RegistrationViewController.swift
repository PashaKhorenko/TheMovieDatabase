//
//  RegistrationViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 18.01.2023.
//

import UIKit
import Lottie

class RegistrationViewController: UIViewController {
    
    private var uiManager: LoginUIHelperProtocol!
    
    // MARK: - UI elements
    
    private lazy var titleLabel = uiManager.makeTitleLalel(text: "Create \nyour account")
    private lazy var signUpButton = uiManager.makeSignUpButtonForRegistration()
    private lazy var logInButton = uiManager.makeLogInButtonForRegisration()
    private lazy var animationView = uiManager.makeAnimationView()
        
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiManager = LoginUIHelper()
        
        delegatesSetup()
        setupViews()
    }
    
    // MARK: - Private
    
    private func delegatesSetup() {
        
    }
    
    private func createAccountAction() {
        print(#function)
    }
    
}

// MARK: - Settings

extension RegistrationViewController {
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(animationView)
        view.addSubview(titleLabel)
        
        view.addSubview(signUpButton)
        view.addSubview(logInButton)
        
        signUpButton.addTarget(self, action: #selector(signUpEmailButtonPressed(_:)), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(logInButtonPressed(_:)), for: .touchUpInside)
        
        setConstraints()
    }
    
    @objc private func signUpEmailButtonPressed(_ sender: UIButton) {
        createAccountAction()
    }
    
    @objc private func logInButtonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}

// MARK: - Constraints

extension RegistrationViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            signUpButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
}
