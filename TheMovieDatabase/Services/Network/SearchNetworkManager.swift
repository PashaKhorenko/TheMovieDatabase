//
//  SearchNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 08.02.2023.
//

import Foundation
import Alamofire

class SearchNetworkManager {
    private let apiKey = "de9681923f09382fe42f437144685b94"
    
    func seacthMoviesBy(_ query: String, _ completion: @escaping (SearchMovies) -> ()) {
        let url = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=en-US&query=\(query)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: SearchMovies.self) { (response) in
                switch response.result {
                case .success:
                    guard let searchMovies = response.value else {
                        print("Empty response data when searching movies")
                        return
                    }
                    completion(searchMovies)
                case .failure(let error):
                    print("Error searching movies: \(error.localizedDescription)")
                }
            }
    }
}
