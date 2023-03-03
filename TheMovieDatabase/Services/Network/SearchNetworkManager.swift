//
//  SearchNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 08.02.2023.
//

import Foundation
import Alamofire

class SearchNetworkManager: SearchNetworkManagerProtocol {

    // MARK: Decoder with convertFromSnakeCase
    func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // MARK: - Search movies
    func searchMoviesBy(_ query: String, _ completion: @escaping (SearchMovies) -> ()) {
        let url = "\(APIConstants.baseURL)/search/movie?api_key=\(APIConstants.apiKey)&language=\(APIConstants.language)&query=\(query)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: SearchMovies.self, decoder: decoder()) { (response) in
                switch response.result {
                case .success(let responseModel):
                    completion(responseModel)
                case .failure(let error):
                    print("Error searching movies: \(error.localizedDescription)")
                }
            }
    }
}
