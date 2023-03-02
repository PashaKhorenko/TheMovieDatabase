//
//  HomeNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 23.01.2023.
//

import Foundation
import Alamofire

class HomeNetworkManager: HomeNetworkManagerProtocol {
    
    // MARK: Decoder with convertFromSnakeCase
    func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
      
    // MARK: - Genres
    func downloadGenres(_ completion: @escaping ([Genre]) -> Void) {
        let url = "\(APIConstants.baseURL)/genre/movie/list?api_key=\(APIConstants.apiKey)&language=\(APIConstants.language)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Genres.self, decoder: decoder()) { (response) in
                switch response.result {
                case .success(let responseModel):
                    guard let genresArray = responseModel.genres else {
                        print("Empty response data when downloading genres")
                        return
                    }
                    completion(genresArray)
                case .failure(let error):
                    print("Error downloading genres: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: - Movies by genre
    func downloadMoviesByGenre(_ genreID: String, _ completion: @escaping (MoviesForCollection) -> ()) {
        let url = "\(APIConstants.baseURL)/discover/movie?api_key=\(APIConstants.apiKey)&language=\(APIConstants.language)&sort_by=popularity.desc&page=1&with_genres=\(genreID)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: MoviesForCollection.self, decoder: decoder()) { (response) in
                switch response.result {
                case .success(let moviesForCollection):
                    completion(moviesForCollection)
                case .failure(let error):
                    print("Error downloading movies by genre: \(error.localizedDescription)")
                }
            }
    }
}
