//
//  SignUpViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 18.01.2023.
//

import UIKit
import Lottie

class SignUpViewController: UIViewController {
    
    private var uiManager: LoginUIHelperProtocol!
    private let viewModel: SignUpViewModelProtocol?
    
    // MARK: - Init
    init(uiManager: LoginUIHelperProtocol! = LoginUIHelper(),
         viewModel: SignUpViewModelProtocol?) {
        self.uiManager = uiManager
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI elements
    private lazy var titleLabel = uiManager.makeTitleLalel(text: "Create \nyour account")
    private lazy var signUpButton = uiManager.makeSignUpButtonForRegistration()
    private lazy var continueAsGuestButton = uiManager.makeContinueAsGuestButton()
    private lazy var logInButton = uiManager.makeLogInButtonForRegisration()
    private lazy var animationView = uiManager.makeAnimationView()
        
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupViews()
        configureViewModelObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel?.storageManager?.deleteAllData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setConstraints()
    }
    
    // MARK: - Private
    private func createAccountAction() {
        self.navigationController?.present(SignUpWebViewController(), animated: true)
    }
    
    private func configureViewModelObservers() {
        self.viewModel?.guestSessionID.bind { [weak self] _ in
            guard let optionalID = self?.viewModel?.guestSessionID.value,
                  let guestSessionID = optionalID else { return }
            
            print("guest session id: \(guestSessionID)")
            
            self?.viewModel?.saveGuestSessionID()
            self?.viewModel?.logInToGuestSession()
        }
    }
    
    private func addButtonsTarget() {
        signUpButton.addTarget(self, action: #selector(signUpEmailButtonPressed(_:)), for: .touchUpInside)
        continueAsGuestButton.addTarget(self, action: #selector(continueAsGuestButtonPressed(_:)), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(logInButtonPressed(_:)), for: .touchUpInside)
    }
    
}

// MARK: - Settings
extension SignUpViewController {
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(animationView)
        view.addSubview(titleLabel)
        
        view.addSubview(signUpButton)
        view.addSubview(continueAsGuestButton)
        view.addSubview(logInButton)
        
        addButtonsTarget()
    }
    
    @objc private func signUpEmailButtonPressed(_ sender: UIButton) {
        createAccountAction()
    }
    
    @objc private func continueAsGuestButtonPressed(_ sender: UIButton) {
        self.viewModel?.featchGuestSessionID()
    }
    
    @objc private func logInButtonPressed(_ sender: UIButton) {
        let loginVM = LoginViewModel(networkManager: LoginNetworkManager(),
                                     storageManager: StorageManager())
        let loginVC = LoginViewController(viewModel: loginVM)
        
        navigationController?.pushViewController(loginVC, animated: true)
    }
}

// MARK: - Constraints
extension SignUpViewController {
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
            
            continueAsGuestButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            continueAsGuestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            continueAsGuestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            continueAsGuestButton.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
}
