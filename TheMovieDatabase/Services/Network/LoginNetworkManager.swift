//
//  LoginNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 19.01.2023.
//

import Foundation
import Alamofire

class LoginNetworkManager {
    
    private let apiKey = "de9681923f09382fe42f437144685b94"
    
    func createNewToken(_ completion: @escaping (String) -> Void) {
        let url = "https://api.themoviedb.org/3/authentication/token/new?api_key=\(self.apiKey)"

        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: RequestToken.self) { (response) in
                switch response.result {
                case .success:
                    guard let requestToken = response.value?.requestToken else {
                        print("Empty response data when receiving a token")
                        return
                    }
                    completion(requestToken)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    func validateUser(withName name: String, password: String, forToken token: String, _ completion: @escaping (Bool) -> ()) {
        let pathString = "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=\(self.apiKey)"
        
        let parameters: [String : String] = [
            "username": name,
            "password": password,
            "request_token": token
        ]
        
        guard let url = URL(string: pathString) else {
            print("Failed to generate URL for validation")
            return
        }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: ValidUser.self) { (response) in
                switch response.result {
                case .success:
                    guard let validateStatus = response.value?.success else {
                        print("Empty response data during user validation")
                        return
                    }
                    completion(validateStatus)
                case .failure(let error):
                    completion(false)
                    print(error.localizedDescription)
                }
            }
    }
    
    func makeSession(withToken token: String, _ completion: @escaping (String) -> ()) {
        let pathString = "https://api.themoviedb.org/3/authentication/session/new?api_key=\(self.apiKey)"
        
        let parameters: [String: String] = ["request_token": token]
        
        guard let url = URL(string: pathString) else {
            print("Failed to create URL to retrieve sessionID")
            return
        }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: SessionID.self) { (response) in
                switch response.result {
                case .success:
                    guard let sessionID = response.value?.sessionID else {
                        print("Empty response data when receiving sessionID")
                        return
                    }
                    completion(sessionID)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    func downloadAccountDetails(sessionID: String, _ completion: @escaping (User) -> ()) {
        let url = "https://api.themoviedb.org/3/account?api_key=\(self.apiKey)&session_id=\(sessionID)"
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: User.self) { (response) in
                switch response.result {
                case .success:
                    guard let user = response.value else {
                        print("Empty response data when receiving account information")
                        return
                    }
                    completion(user)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
