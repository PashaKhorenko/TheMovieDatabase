//
//  HomeNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 23.01.2023.
//

import Foundation
import Alamofire

protocol HomeNetworkManagerProtocol {
    
    func downloadGenres(_ completion: @escaping ([Genre]) -> Void)
    func downloadMoviesByGenre(_ genreID: String, _ completion: @escaping (MoviesForCollection) -> Void)
}

class HomeNetworkManager: HomeNetworkManagerProtocol {
    
    private let apiKey = "de9681923f09382fe42f437144685b94"
    
    func downloadGenres(_ completion: @escaping ([Genre]) -> Void) {
        let url = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(self.apiKey)&language=en-US"
        
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
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=\(self.apiKey)&language=en-US&sort_by=popularity.desc&page=1&with_genres=\(genreID)"
        
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
