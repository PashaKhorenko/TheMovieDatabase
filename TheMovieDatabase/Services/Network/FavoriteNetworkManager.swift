//
//  FavoriteNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 01.02.2023.
//

import Foundation
import Alamofire

class FavoriteNetworkManager: FavoriteNetworkManagerProtocol {
    
    // MARK: Decoder with convertFromSnakeCase
    func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // MARK: - Download favorite movies
    func downloadFavoriteMovies(accountID: Int, sessionID: String, _ completion: @escaping ([FavoriteMovie]) -> ()) {
        let url = "\(APIConstants.baseURL)/account/\(accountID)/favorite/movies?api_key=\(APIConstants.apiKey)&session_id=\(sessionID)&sort_by=created_at.asc"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: FavoriteMovies.self, decoder: decoder()) { (response) in
                switch response.result {
                case .success(let responseModel):
                    guard let favoriteMovies = responseModel.results else {
                        print("Empty response data when downloading favoirite movies")
                        return
                    }
                    completion(favoriteMovies)
                case .failure(let error):
                    print("Error downloading favoirite movies: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: - Remove from favorites
    func removeFromFavorites(accountID: Int, sessionID: String, movieID: Int, _ completion: @escaping () -> ()) {
        let pathString = "\(APIConstants.baseURL)/account/\(accountID)/favorite?api_key=\(APIConstants.apiKey)&session_id=\(sessionID)"
        
        guard let url = URL(string: pathString) else {
            print("Failed to generate URL for validation")
            return
        }
        
        let parameters: [String: Any] = [
            "media_type": "movie",
              "media_id": movieID,
              "favorite": false
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: FavoritesStatusResponse.self, decoder: decoder()) { (response) in
                switch response.result {
                case .success(let responseModel):
                    guard let statusMessage = responseModel.statusMessage else {
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
