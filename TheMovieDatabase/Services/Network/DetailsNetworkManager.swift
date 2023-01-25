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
}
