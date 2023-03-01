//
//  HomeNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 23.01.2023.
//

import Foundation
import Alamofire

class HomeNetworkManager: HomeNetworkManagerProtocol {
        
    func downloadGenres(_ completion: @escaping ([Genre]) -> Void) {
        let url = "\(APIConstants.baseURL)/genre/movie/list?api_key=\(APIConstants.apiKey)&language=\(APIConstants.language)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Genres.self) { (response) in
                switch response.result {
                case .success:
                    guard let genres = response.value?.genres else {
                        print("Empty response data when downloading genres")
                        return
                    }
                    completion(genres)
                case .failure(let error):
                    print("Error downloading genres: \(error.localizedDescription)")
                }
            }
    }
    
    func downloadMoviesByGenre(_ genreID: String, _ completion: @escaping (MoviesForCollection) -> ()) {
        let url = "\(APIConstants.baseURL)/discover/movie?api_key=\(APIConstants.apiKey)&language=\(APIConstants.language)&sort_by=popularity.desc&page=1&with_genres=\(genreID)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: MoviesForCollection.self) { (response) in
                switch response.result {
                case .success:
                    guard let movies = response.value else {
                        print("Empty response data when downloading movies by genre")
                        return
                    }
                    completion(movies)
                case .failure(let error):
                    print("Error downloading movies by genre: \(error.localizedDescription)")
                }
            }
    }
}
