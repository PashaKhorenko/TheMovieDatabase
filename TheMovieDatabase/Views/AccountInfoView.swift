//
//  AccountInfoView.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 03.02.2023.
//

import UIKit

class AccountInfoView: UIView {
    
    // MARK: - UI elements
    private let nameInAvatarLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "Avenir Next Bold", size: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = .randomColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.font = UIFont(name: "Avenir Next", size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let accountIdLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .secondaryLabel
        label.font = UIFont(name: "Avenir Next", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.avatarView.layer.cornerRadius = self.avatarView.frame.height / 2
    }
    
    // MARK: - Private
    private func setupViews() {
        // self setup
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.backgroundColor = .systemBackground
        
        // add subview
        avatarView.addSubview(nameInAvatarLabel)
        self.addSubview(avatarView)
        labelsStackView.addArrangedSubview(usernameLabel)
        labelsStackView.addArrangedSubview(accountIdLabel)
        self.addSubview(labelsStackView)
              
        // constraints
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameInAvatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            nameInAvatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            avatarView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            avatarView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor, multiplier: 1),
            
            labelsStackView.topAnchor.constraint(equalTo: avatarView.topAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            usernameLabel.heightAnchor.constraint(equalTo: accountIdLabel.heightAnchor, multiplier: 1)
        ])
    }
    
    // MARK: - Public
    func configure(with accountDetails: AccountDetailsRealm) {
        let username = accountDetails.username
        self.usernameLabel.text = username
        
        let id = accountDetails.id
        self.accountIdLabel.text = "Acoount ID: \(id)"
        
        guard let firstLetterInUsername = username.first else { return }
        self.nameInAvatarLabel.text = "\(firstLetterInUsername)"
    }
    
}
