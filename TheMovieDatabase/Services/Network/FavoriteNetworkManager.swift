//
//  FavoriteNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 01.02.2023.
//

import Foundation
import Alamofire

class FavoriteNetworkManager {
    private let apiKey = "de9681923f09382fe42f437144685b94"
    
    func downloadFavoriteMovies(accountID: Int, sessionID: String, _ completion: @escaping (FavoriteMovies) -> ()) {
        let url = "https://api.themoviedb.org/3/account/\(accountID)/favorite/movies?api_key=\(apiKey)&session_id=\(sessionID)&sort_by=created_at.asc"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: FavoriteMovies.self) { (response) in
                switch response.result {
                case .success:
                    guard let favoriteMovies = response.value else {
                        print("Empty response data when downloading favoirite movies")
                        return
                    }
                    completion(favoriteMovies)
                case .failure(let error):
                    print("Error downloading favoirite movies: \(error.localizedDescription)")
                }
            }
        
    }
}
