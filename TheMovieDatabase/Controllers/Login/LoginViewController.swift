//
//  LoginViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 18.01.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var uiManager: LoginUIHelperProtocol!
    private let viewModel: LoginViewModelProtocol?
    
    // MARK: - Init
    init(uiManager: LoginUIHelperProtocol! = LoginUIHelper(),
         viewModel: LoginViewModelProtocol?) {
        self.uiManager = uiManager
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI elements
    private lazy var animationView = uiManager.makeAnimationView()
    private lazy var titleLabel = uiManager.makeTitleLalel(text: "Log into \nyour account")
    private lazy var textFieldsStackView = uiManager.makeStackView(asix: .vertical)
    private lazy var usernameTextField = uiManager.makeUsernameTextField()
    private lazy var passwordTextField = uiManager.makePasswordTextField()
    private lazy var logInButton = uiManager.makeLogInButtonForLogin()
    private let activityIndicator = StandartActivityIndicator(frame: .zero)
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiManager = LoginUIHelper()
        
        delegatesSetup()
        setupViews()
        configureViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    // MARK: - Private
    private func delegatesSetup() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func logIntoAccountAction() {
        self.activityIndicator.startAnimating()
        self.viewModel?.fetchRequestToken()
    }
    
    // Data binding
    private func configureViewModelObserver() {
        // When we received the RequestToken, we take the text from UITextFieds,
        // check them and send the data for user validation.
        self.viewModel?.requestToken.bind { [weak self] _ in
            guard let requestTokenOptional = self?.viewModel?.requestToken.value,
                  let _ = requestTokenOptional else { return }
//            print("Request Token: \(requestToken)")
            
            guard let usernameText = self?.usernameTextField.text, !usernameText.isEmpty,
                  let passwordText = self?.passwordTextField.text, !passwordText.isEmpty else {
                print("Empty username or password text field")
                return
            }
            
            guard let username = self?.viewModel?.getValidText(usernameText),
                  let password = self?.viewModel?.getValidText(passwordText) else { return }
            
            self?.viewModel?.validateUser(withName: username,
                                          password: password)
        }
        
        // When we receive a response about the validity of the user, we make a request
        // to receive the SessionID or show a message about a validation error.
        self.viewModel?.isValidUser.bind { [weak self] _ in
            guard let isValidUserOptional = self?.viewModel?.isValidUser.value,
                  let isValidUser = isValidUserOptional else { return }
//            print("Is Valid User: \(isValidUser)")
            
            guard isValidUser else {
                self?.activityIndicator.stopAnimating()
                self?.showAlert()
                return
            }
            
            self?.viewModel?.featchSessionID()
        }
        
        // After receiving the SessionID, we save it to Realm and make a request
        // to receive AccountDetails.
        self.viewModel?.sessionId.bind { [weak self] _ in
//            guard let sessionIdOptional = self?.viewModel?.sessionId.value,
//                  let sessionId = sessionIdOptional else { return }
//            print("Session ID: \(sessionId)")
            
            self?.viewModel?.saveSessionID()
            self?.viewModel?.featchAccountDetails()
            
        }
        
        // After receiving the AccountDetails we save them in Realm and log in to the account.
        self.viewModel?.accountDetails.bind { [weak self] _ in
            guard let optionalAccountDetails = self?.viewModel?.accountDetails.value,
                  let accountDetails = optionalAccountDetails else { return }
//            print("Account Details: \(accountDetails)")
            
            self?.viewModel?.saveAccountDetails(accountDetails)
            
            self?.activityIndicator.stopAnimating()
            self?.viewModel?.loginToTheAccount()
        }
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Login error",
                                                message: "Incorrectly entered username or password",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

// MARK: - Settings

extension LoginViewController {
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem()
        backButton.title = "Sign Up"
        backButton.tintColor = .label
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setupViews() {
        activityIndicator.stopAnimating()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        
        view.addSubview(animationView)
        view.addSubview(titleLabel)
        
        view.addSubview(textFieldsStackView)
        textFieldsStackView.addArrangedSubview(usernameTextField)
        textFieldsStackView.addArrangedSubview(passwordTextField)
        
        view.addSubview(logInButton)
        view.addSubview(activityIndicator)
        
        logInButton.addTarget(self, action: #selector(logInButtonPressed(_:)), for: .touchUpInside)
        
        setConstraints()
    }
    
    @objc private func logInButtonPressed(_ sender: UIButton) {
        logIntoAccountAction()
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let userNameText = usernameTextField.text,
              let passwordText = passwordTextField.text else { return }
        
        if userNameText.count != 0 && passwordText.count >= 4 {
            logInButton.isEnabled = true
        } else {
            logInButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            return false
        }
        return true
    }
}

// MARK: - Keyboard operations

extension LoginViewController {
    
    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // create keyboard show/hide observers
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UITextView.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UITextView.keyboardWillHideNotification, object: nil)
    }
    
    // remove keyboard show/hide observers
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UITextView.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.keyboardWillHideNotification, object: nil)
    }
    
    // raises the screen above the keyboard
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height / 1.5
        }
    }
    
    // lower everything back when hiding the keyboard
    @objc func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

// MARK: - Constraints

extension LoginViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            textFieldsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            textFieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textFieldsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            usernameTextField.heightAnchor.constraint(equalToConstant: 45),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            logInButton.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 30),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 20),
        ])
    }
}
