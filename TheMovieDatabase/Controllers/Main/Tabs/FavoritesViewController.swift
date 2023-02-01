//
//  FavoritesViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit
import Alamofire
import RealmSwift

class FavoritesViewController: UIViewController {
    
    private let realm = try! Realm()
    private var accountDetails: Results<AccountDetailsRealm>!
    private var sessionID: Results<SessionIDRealm>!
    
    private let detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Details", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountDetails = realm.objects(AccountDetailsRealm.self)
        sessionID = realm.objects(SessionIDRealm.self)

        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        detailsButton.addTarget(self, action: #selector(detailsButtonPressed(_:)), for: .touchUpInside)

        view.addSubview(detailsButton)
        
        NSLayoutConstraint.activate([
            detailsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailsButton.widthAnchor.constraint(equalToConstant: 150),
            detailsButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFavouritesMovie()
    }
    
    private func getFavouritesMovie() {
        guard let accountID = accountDetails.first?.id,
              let sessionID = sessionID.first?.id else { return }
        
        let apiKey = "de9681923f09382fe42f437144685b94"
        let url = "https://api.themoviedb.org/3/account/\(accountID)/favorite/movies?api_key=\(apiKey)&session_id=\(sessionID)&sort_by=created_at.asc"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: FavoriteMovies.self) { (response) in
                switch response.result {
                case .success:
                    guard let movies = response.value?.results else {
                        print("Empty response data when downloading favoirite movies")
                        return
                    }
                    print(movies)
                case .failure(let error):
                    print("Error downloading favoirite movies: \(error.localizedDescription)")
                }
            }
    }
    
    @objc func detailsButtonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(DetailsViewController(), animated: true)
    }
}
