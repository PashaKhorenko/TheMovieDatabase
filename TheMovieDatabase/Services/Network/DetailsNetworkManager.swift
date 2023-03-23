//
//  DetailsNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 24.01.2023.
//

import Foundation
import Alamofire

class DetailsNetworkManager: DetailsNetworkManagerProtocol {
    
    // MARK: Decoder with convertFromSnakeCase
    func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
       
    // MARK: - Download movies
    func downloadMovie(withID movieID: Int, _ completion: @escaping (MovieForDetails) -> Void) {
        let url = "\(APIConstants.baseURL)/movie/\(movieID)?api_key=\(APIConstants.apiKey)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: MovieForDetails.self, decoder: decoder()) { (response) in
                switch response.result {
                case .success(let movieForDetails):
                    completion(movieForDetails)
                case .failure(let error):
                    print("Error downloading details movie: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: - Download image data
    func downloadImageData(byPath path: String, _ completion: @escaping (Data) -> ()) {
        let url = "\(APIConstants.baseImageURL)/\(path)"
        
        AF.request(url)
            .response { response in
                guard response.error == nil else {
                    print(response.error!.localizedDescription)
                    return
                }
                guard let data = response.data else { return }
                completion(data)
            }
    }
    
    // MARK: - Download video
    func downloadVideo(withID movieId: Int, _ completion: @escaping ([Video]) -> ()) {
        let url = "\(APIConstants.baseURL)/movie/\(movieId)/videos?api_key=\(APIConstants.apiKey)&language=\(APIConstants.language)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Videos.self, decoder: decoder()) { (response) in
                switch response.result {
                case .success(let responseModel):
                    guard let videoArray = responseModel.results else {
                        print("Empty response data when downloading video")
                        return
                    }
                    completion(videoArray)
                case .failure(let error):
                    print("Error downloading details movie: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: - Mark as favorite
    func markAsFavoriteOrUnfavorite(accountID: Int,
                                    sessionID: String,
                                    movieID: Int,
                                    favoritesState: Bool,
                                    _ completion: @escaping (String, Bool) -> ()) {
        let pathString = "\(APIConstants.baseURL)/account/\(accountID)/favorite?api_key=\(APIConstants.apiKey)&session_id=\(sessionID)"
        
        guard let url = URL(string: pathString) else {
            print("Failed to generate URL for validation")
            return
        }
        
        let parameters: [String: Any] = [
            "media_type": "movie",
              "media_id": movieID,
              "favorite": favoritesState
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: FavoritesStatusResponse.self, decoder: decoder()) { (response) in
                switch response.result {
                case .success(let responseModel):
                    guard let statusMessage = responseModel.statusMessage,
                          let statusCode = responseModel.statusCode else {
                        print("Empty response data during user validation")
                        return
                    }
                    print("Status code: \(statusCode), Status massege: \(statusMessage)")
                    
                    switch statusCode {
                    case 1:
                        let message = "The movie has been successfully added to your favorites list."
                        completion(message, true)
                    case 2...11: completion(statusMessage, false)
                    case 13:
                        let message = "The movie has been successfully removed from your favorites list."
                        completion(message, false)
                    default: completion(statusMessage, !favoritesState)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
