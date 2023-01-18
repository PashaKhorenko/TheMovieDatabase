//
//  RegistrationViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 18.01.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    private let uiManager = UIManager()
    
    // MARK: - UI elements
    
    private lazy var titleLabel = uiManager.makeTitleLalel(text: "Create \nyour account")
    private lazy var textFieldsStack = uiManager.makeStackView(asix: .vertical)
    private lazy var usernameTextField = uiManager.makeUsernameTextField()
    private lazy var emailTextField = uiManager.makeEmailTextField()
    private lazy var passwordTextField = uiManager.makePasswordTextField()
    private lazy var signUpButton = uiManager.makeSignUpButtonForRegistration()
    private lazy var separatorLabel = uiManager.makeSeparatorLabel()
    private lazy var buttonsStackView = uiManager.makeStackView(asix: .horizontal)
    private lazy var appleButton = uiManager.makeAppleButton()
    private lazy var googleButton = uiManager.makeGoogleButton()
    private lazy var facebookButton = uiManager.makeFacebookButton()
    private lazy var logInButton = uiManager.makeLogInButtonForRegisration()
    
    
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
        
        view.addSubview(textFieldsStack)
        textFieldsStack.addArrangedSubview(usernameTextField)
        textFieldsStack.addArrangedSubview(emailTextField)
        textFieldsStack.addArrangedSubview(passwordTextField)
        
        view.addSubview(signUpButton)
        
        view.addSubview(separatorLabel)
        
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(appleButton)
        buttonsStackView.addArrangedSubview(googleButton)
        buttonsStackView.addArrangedSubview(facebookButton)
        
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
            self.view.frame.origin.y -= keyboardSize.height / 3
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
            titleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            textFieldsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            textFieldsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textFieldsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            usernameTextField.heightAnchor.constraint(equalToConstant: 45),
            emailTextField.heightAnchor.constraint(equalToConstant: 45),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            signUpButton.topAnchor.constraint(equalTo: textFieldsStack.bottomAnchor, constant: 30),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            separatorLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 15),
            separatorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            separatorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            buttonsStackView.topAnchor.constraint(equalTo: separatorLabel.bottomAnchor, constant: 15),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50),
            
            googleButton.widthAnchor.constraint(equalTo: appleButton.widthAnchor, multiplier: 1),
            facebookButton.widthAnchor.constraint(equalTo: appleButton.widthAnchor, multiplier: 1),
            
            logInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
}
