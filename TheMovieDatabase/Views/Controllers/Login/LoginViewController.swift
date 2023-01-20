//
//  LoginViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 18.01.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var uiManager: LoginUIHelperProtocol!
    private let viewModel = LoginViewModel()
    
    // MARK: - UI elements
    private lazy var animationView = uiManager.makeAnimationView()
    private lazy var titleLabel = uiManager.makeTitleLalel(text: "Log into \nyour account")
    private lazy var textFieldsStackView = uiManager.makeStackView(asix: .vertical)
    private lazy var usernameTextField = uiManager.makeUsernameTextField()
    private lazy var passwordTextField = uiManager.makePasswordTextField()
    private lazy var logInButton = uiManager.makeLogInButtonForLogin()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiManager = LoginUIHelper()
        
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
        passwordTextField.delegate = self
    }
    
    private func logIntoAccountAction() {
        print(#function)
        
        guard let usernameText = self.usernameTextField.text, !usernameText.isEmpty,
              let passwordText = self.passwordTextField.text, !passwordText.isEmpty else {
            print("Empty username or password text field")
            return
        }
        
        let username = self.viewModel.getValidText(usernameText)
        let password = self.viewModel.getValidText(passwordText)
        
        self.viewModel.fetchRequestToken {
            print("Token received")
            self.viewModel.validateUser(withName: username,
                                        password: password) {
                print("Validation User")
                self.viewModel.featchSessionID { id in
                    print("SessionID: \(id)")
                    
                    let tabBarController = MainTabBarController()
                    self.present(tabBarController, animated: true)
                }
            }
        }
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
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        
        view.addSubview(animationView)
        view.addSubview(titleLabel)
        
        view.addSubview(textFieldsStackView)
        textFieldsStackView.addArrangedSubview(usernameTextField)
        textFieldsStackView.addArrangedSubview(passwordTextField)
        
        view.addSubview(logInButton)
        
        logInButton.addTarget(self, action: #selector(logInButtonPressed(_:)), for: .touchUpInside)
        
        setConstraints()
    }
    
    @objc private func logInButtonPressed(_ sender: UIButton) {
        logIntoAccountAction()
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
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
            logInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
