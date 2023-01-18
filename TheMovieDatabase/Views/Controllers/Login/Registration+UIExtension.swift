//
//  Registration+UIExtension.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 18.01.2023.
//

import UIKit

extension RegistrationViewController {
    
    func makeTitleLalel() -> UILabel {
        let label = UILabel()
        label.text = "Create \nyour account"
        label.font = .boldSystemFont(ofSize: 40)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeUsernameTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Your username"
        textField.borderStyle = .roundedRect
//        textField.layer.cornerRadius = 25
//        textField.clipsToBounds = true
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
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func makeSignUpButton() -> UIButton {
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
        button.setTitle("Sign up with Apple", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeGoogleButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Sign up with Google", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeFacebookButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Sign up with Facebook", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeLogInButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Already have account? Log In.", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
