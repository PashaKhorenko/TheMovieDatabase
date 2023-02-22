//
//  DetailsNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 24.01.2023.
//

import Foundation
import Alamofire

class DetailsNetworkManager: DetailsNetworkManagerProtocol {
    
    private let apiKey = "de9681923f09382fe42f437144685b94"
    
    func downloadMovie(withID movieID: Int, _ completion: @escaping (MovieForDetails) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(self.apiKey)"
        
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
        let url = "https://image.tmdb.org/t/p/w500/\(path)"
        
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
        let url = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(self.apiKey)&language=en-US"
        
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
        let pathString = "https://api.themoviedb.org/3/account/\(accountID)/favorite?api_key=\(self.apiKey)&session_id=\(sessionID)"
        
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
