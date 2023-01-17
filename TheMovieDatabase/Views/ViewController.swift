//
//  ViewController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 16.01.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    private let apiKey = "5596b19dd1f5e2efb7f5a6e4cf3431f8"
    private var genresURL: String {
        "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)&language=en-US"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brown
        navigationItem.title = "ViewController"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        downloadGenres(byPath: genresURL)
    }
    
    // MARK: - Downloading Genres
       
       func downloadGenres(byPath url: String) {
           AF.request(url)
               .validate()
               .responseDecodable(of: Genres.self) { (response) in
                   guard let genres = response.value?.genres else { return }
                   
                   print(genres)
               }
       }
}

