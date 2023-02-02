//
//  UIManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 18.01.2023.
//

import UIKit
import Lottie

protocol LoginUIHelperProtocol {
    func makeTitleLalel(text: String) -> UILabel
    func makeUsernameTextField() -> UITextField
    func makePasswordTextField() -> UITextField
    func makeStackView(asix: NSLayoutConstraint.Axis) -> UIStackView
    func makeSignUpButtonForRegistration() -> UIButton
    func makeLogInButtonForRegisration() -> UIButton
    func makeLogInButtonForLogin() -> UIButton
    func makeAnimationView() -> LottieAnimationView
}

struct LoginUIHelper: LoginUIHelperProtocol {
    
    // MARK: - Shared
    func makeTitleLalel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 40)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    func makeStackView(asix: NSLayoutConstraint.Axis) -> UIStackView {
        let stack = UIStackView()
        stack.spacing = 15
        stack.axis = asix
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    func makeAnimationView() -> LottieAnimationView {
        let view = LottieAnimationView(name: "loginAnimation")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.loopMode = .loop
        view.animationSpeed = 1
        view.play()
        return view
    }

    // MARK: - For registration
    func makeSignUpButtonForRegistration() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    func makeLogInButtonForRegisration() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Already have account? Log In.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - For login
    func makeUsernameTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Your username"
        textField.borderStyle = .roundedRect
        textField.tintColor = .lightGray
        textField.setIcon(UIImage(systemName: "person")!)
        textField.autocapitalizationType = .words
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    func makePasswordTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.tintColor = .lightGray
        textField.setIcon(UIImage(systemName: "lock")!)
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    func makeLogInButtonForLogin() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
