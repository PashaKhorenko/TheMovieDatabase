//
//  RegistrationViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 18.01.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    // MARK: - UI elements
    
    private lazy var titleLabel = self.makeTitleLalel()
    private lazy var usernameTextField = self.makeUsernameTextField()
    private lazy var emailTextField = self.makeEmailTextField()
    private lazy var passwordTextField = self.makePasswordTextField()
    private lazy var signUpButton = self.makeSignUpButton()
    private lazy var appleButton = self.makeAppleButton()
    private lazy var googleButton = self.makeGoogleButton()
    private lazy var facebookButton = self.makeFacebookButton()
    private lazy var logInButton = self.makeLogInButton()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegatesSetup()
        setupViews()
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
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func createAccountAction() {
        print(#function)
//        navigationController?.pushViewController(MainTabBarController(), animated: true)
    }
    
}

// MARK: - Settings

extension RegistrationViewController {
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)

        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)

        view.addSubview(signUpButton)
//        view.addSubview(appleButton)
//        view.addSubview(googleButton)
//        view.addSubview(facebookButton)
        
        view.addSubview(logInButton)
        
        signUpButton.addTarget(self, action: #selector(signUpEmailButtonPressed(_:)), for: .touchUpInside)
        
        appleButton.addTarget(self, action: #selector(signUpAnotherButtonPressed(_:)), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(signUpAnotherButtonPressed(_:)), for: .touchUpInside)
        facebookButton.addTarget(self, action: #selector(signUpAnotherButtonPressed(_:)), for: .touchUpInside)
        
        logInButton.addTarget(self, action: #selector(logInButtonPressed(_:)), for: .touchUpInside)
        
        setConstraints()
    }
    
    @objc private func signUpEmailButtonPressed(_ sender: UIButton) {
        createAccountAction()
    }
    
    @objc private func signUpAnotherButtonPressed(_ sender: UIButton) {
        print(sender.titleLabel!.text!)
    }
    
    @objc private func logInButtonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}

// MARK: - Keyboard operations

extension RegistrationViewController {
    
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
            self.view.frame.origin.y -= keyboardSize.height / 4
        }
    }
    
    // lower everything back when hiding the keyboard
    @objc func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            return false
        }
        return true
    }
}

// MARK: - Constraints

extension RegistrationViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            usernameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            usernameTextField.heightAnchor.constraint(equalToConstant: 45),

            emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 15),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailTextField.heightAnchor.constraint(equalToConstant: 45),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),

            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),

//            appleButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 15),
//            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
//            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            appleButton.heightAnchor.constraint(equalToConstant: 50),
//
//            googleButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 15),
//            googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
//            googleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            googleButton.heightAnchor.constraint(equalToConstant: 50),
//
//            facebookButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 15),
//            facebookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
//            facebookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            facebookButton.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
}
