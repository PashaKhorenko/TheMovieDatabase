//
//  SearchNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 08.02.2023.
//

import Foundation
import Alamofire

class SearchNetworkManager: SearchNetworkManagerProtocol {
    
    func seacthMoviesBy(_ query: String, _ completion: @escaping (SearchMovies) -> ()) {
        let url = "\(APIConstants.baseURL)/search/movie?api_key=\(APIConstants.apiKey)&language=\(APIConstants.language)&query=\(query)"
        
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
