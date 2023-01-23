//
//  HomeNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 23.01.2023.
//

import Foundation
import Alamofire

class HomeNetworkManager {
    
    private let apiKey = "de9681923f09382fe42f437144685b94"
    
    func downloadGenres(_ completion: @escaping ([GenreServerResponse]) -> Void) {
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
    
    func downloadMovies(fromPage page: Int, _ completion: @escaping (Movies) -> ()) {
        let url = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=\(page)"
        AF.request(url)
            .validate()
            .responseDecodable(of: Movies.self) { (response) in
                switch response.result {
                case .success:
                    guard let movies = response.value else {
                        print("Empty response data when downloading movies")
                        return
                    }
                    completion(movies)
                case .failure(let error):
                    print("Error downloading movies: \(error.localizedDescription)")
                }
            }
    }
}

