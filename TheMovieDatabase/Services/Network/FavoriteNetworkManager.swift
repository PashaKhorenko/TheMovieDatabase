//
//  FavoriteNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 01.02.2023.
//

import Foundation
import Alamofire

class FavoriteNetworkManager: FavoriteNetworkManagerProtocol {
    private let apiKey = "de9681923f09382fe42f437144685b94"
    
    func downloadFavoriteMovies(accountID: Int, sessionID: String, _ completion: @escaping ([FavoriteMovie]) -> ()) {
        let url = "https://api.themoviedb.org/3/account/\(accountID)/favorite/movies?api_key=\(apiKey)&session_id=\(sessionID)&sort_by=created_at.asc"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: FavoriteMovies.self) { (response) in
                switch response.result {
                case .success:
                    guard let favoriteMovies = response.value?.results else {
                        print("Empty response data when downloading favoirite movies")
                        return
                    }
                    completion(favoriteMovies)
                case .failure(let error):
                    print("Error downloading favoirite movies: \(error.localizedDescription)")
                }
            }
    }
    
    func removeFromFavorites(accountID: Int, sessionID: String, movieID: Int, _ completion: @escaping () -> ()) {
        let pathString = "https://api.themoviedb.org/3/account/\(accountID)/favorite?api_key=\(self.apiKey)&session_id=\(sessionID)"
        
        let parameters: [String: Any] = [
            "media_type": "movie",
              "media_id": movieID,
              "favorite": false
        ]
        
        guard let url = URL(string: pathString) else {
            print("Failed to generate URL for validation")
            return
        }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: FavoritesStatusResponse.self) { (response) in
                switch response.result {
                case .success:
                    guard let statusMessage = response.value?.statusMessage else {
                        print("Empty response data during user validation")
                        return
                    }
                    switch statusMessage {
                    case "The item/record was deleted successfully.": completion()
                    default: print(statusMessage)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
    }
}
