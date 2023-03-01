//
//  CompanyCollectionViewCell.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 06.02.2023.
//

import UIKit
import SDWebImage

class CompanyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI elements
    private let activityIndicator = StandartActivityIndicator(frame: .zero)
    private let companyLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setupViews() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 20
        clipsToBounds = true
        
        companyLogoImageView.addSubview(activityIndicator)
        addSubview(companyLogoImageView)
        
        NSLayoutConstraint.activate([
            companyLogoImageView.topAnchor.constraint(equalTo: topAnchor),
            companyLogoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            companyLogoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            companyLogoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: companyLogoImageView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: companyLogoImageView.centerXAnchor),
        ])
    }
    
    // MARK: - Public
    func configureWith(_ company: ProductionCompany?) {
        guard let logoParh = company?.logoPath else { return }
        
        let URLstring = "\(APIConstants.baseImageURL)/\(logoParh)"
        guard let url = URL(string: URLstring) else {
            print("Failure company logo image url configuration")
            return
        }
        
        DispatchQueue.main.async {
            self.companyLogoImageView.sd_setImage(with: url) { (_, _, _, _) in
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
}
