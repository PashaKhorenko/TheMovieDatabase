//
//  UIManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 18.01.2023.
//

import UIKit

struct UIManager {
    
    // MARK: - Shared
    
    func makeTitleLalel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 40)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    func makeSeparatorLabel() -> UILabel {
        let label = UILabel()
        label.text = "Or sign up using"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
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
    func makeEmailTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.tintColor = .lightGray
        textField.setIcon(UIImage(systemName: "envelope")!)
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
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
    
    func makeStackView(asix: NSLayoutConstraint.Axis) -> UIStackView {
        let stack = UIStackView()
        stack.spacing = 15
        stack.axis = asix
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    
    // MARK: - For registration
    func makeSignUpButtonForRegistration() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondaryLabel
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeAppleButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Apple", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    func makeGoogleButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Google", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    func makeFacebookButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Facebook", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemFill
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
    func makeLogInButtonForLogin() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondaryLabel
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
