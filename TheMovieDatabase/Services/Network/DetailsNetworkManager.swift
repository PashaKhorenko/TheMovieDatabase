//
//  DetailsNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 24.01.2023.
//

import Foundation
import Alamofire

class DetailsNetworkManager: DetailsNetworkManagerProtocol {
        
    func downloadMovie(withID movieID: Int, _ completion: @escaping (MovieForDetails) -> Void) {
        let url = "\(APIConstants.baseURL)/movie/\(movieID)?api_key=\(APIConstants.apiKey)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: MovieForDetails.self) { (response) in
                switch response.result {
                case .success:
                    guard let movie = response.value else {
                        print("Empty response data when downloading movie details")
                        return
                    }
                    completion(movie)
                case .failure(let error):
                    print("Error downloading details movie: \(error.localizedDescription)")
                }
            }
    }
    
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
    
    func downloadVideo(withID movieId: Int, _ completion: @escaping ([Video]) -> ()) {
        let url = "\(APIConstants.baseURL)/movie/\(movieId)/videos?api_key=\(APIConstants.apiKey)&language=\(APIConstants.language)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Videos.self) { (response) in
                switch response.result {
                case .success:
                    guard let videoArray = response.value?.results else {
                        print("Empty response data when downloading video")
                        return
                    }
                    completion(videoArray)
                case .failure(let error):
                    print("Error downloading details movie: \(error.localizedDescription)")
                }
            }
    }
    
    func markAsFavorite(accountID: Int, sessionID: String, movieID: Int, _ completion: @escaping (Bool) -> ()) {
        let pathString = "\(APIConstants.baseURL)/account/\(accountID)/favorite?api_key=\(APIConstants.apiKey)&session_id=\(sessionID)"
        
        let parameters: [String: Any] = [
            "media_type": "movie",
              "media_id": movieID,
              "favorite": true
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
                    print(statusMessage)
                    switch statusMessage {
                    case "Success.": completion(true)
                    default: completion(false)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
