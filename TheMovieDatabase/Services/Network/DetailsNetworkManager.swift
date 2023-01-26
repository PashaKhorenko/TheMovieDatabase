//
//  DetailsNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 24.01.2023.
//

import Foundation
import Alamofire

class DetailsNetworkManager {
    
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
    
    func downloadVideo(withID movieId: Int, _ completion: @escaping (Video) -> ()) {
        let url = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(self.apiKey)&language=en-US"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Video.self) { (response) in
                switch response.result {
                case .success:
                    guard let video = response.value else {
                        print("Empty response data when downloading video")
                        return
                    }
                    completion(video)
                case .failure(let error):
                    print("Error downloading details movie: \(error.localizedDescription)")
                }
            }
    }
}
