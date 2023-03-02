//
//  LoginNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 19.01.2023.
//

import Foundation
import Alamofire

class LoginNetworkManager: LoginNetworkManagerProtocol {
    
    // MARK: Decoder with convertFromSnakeCase
    func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // MARK: - Request Token
    func createNewToken(_ completion: @escaping (String) -> Void) {
        let url = "\(APIConstants.baseURL)/authentication/token/new?api_key=\(APIConstants.apiKey)"

        AF.request(url)
            .validate()
            .responseDecodable(of: RequestToken.self, decoder: decoder()) { (response) in
                switch response.result {
                case .success(let responseModel):
                    guard let requestToken = responseModel.requestToken else {
                        print("Empty response data when receiving requestToken")
                        return
                    }
                    completion(requestToken)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    // MARK: - User Validation
    func validateUser(withName name: String, password: String, forToken token: String, _ completion: @escaping (Bool) -> ()) {
        let pathString = "\(APIConstants.baseURL)/authentication/token/validate_with_login?api_key=\(APIConstants.apiKey)"
        
        guard let url = URL(string: pathString) else {
            print("Failed to generate URL for validation")
            return
        }
        
        let parameters: [String : String] = [
            "username": name,
            "password": password,
            "request_token": token
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: ValidUser.self) { (response) in
                switch response.result {
                case .success(let responseModel):
                    guard let isValidUser = responseModel.success else { return }
                    completion(isValidUser)
                case .failure(let error):
                    completion(false)
                    print(error.localizedDescription)
                }
            }
    }
    
    // MARK: - Session ID
    func makeSession(withToken token: String, _ completion: @escaping (String) -> ()) {
        let pathString = "\(APIConstants.baseURL)/authentication/session/new?api_key=\(APIConstants.apiKey)"
        
        guard let url = URL(string: pathString) else {
            print("Failed to create URL to retrieve sessionID")
            return
        }
        
        let parameters: [String: String] = ["request_token": token]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: SessionID.self) { response in
                switch response.result {
                case .success(let responseModel):
                    guard let sessionID = responseModel.sessionID else {
                        print("Empty response data when receiving sessionID")
                        return
                    }
                    completion(sessionID)
                case .failure(let error):
                    print("Error getting sessionID: \(error.localizedDescription)")
                }
            }
    }
    
    // MARK: - Account Details
    func downloadAccountDetails(sessionID: String, _ completion: @escaping (User) -> ()) {
        let url = "\(APIConstants.baseURL)/account?api_key=\(APIConstants.apiKey)&session_id=\(sessionID)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: User.self, decoder: decoder()) { (response) in
                switch response.result {
                case .success(let responseModel):
                    completion(responseModel)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
