//
//  SettingsNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 14.03.2023.
//

import Foundation
import Alamofire

final class SettingsNetworkManager: SettingsNetworkManagerProtocol {
    
    // MARK: Decoder with convertFromSnakeCase
    func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // MARK: - Delete session id
    func deleteCurrent(sessiondID: String, _ completion: @escaping (Bool) -> Void) {
        let pathString = "\(APIConstants.baseURL)/authentication/session?api_key=\(APIConstants.apiKey)"
        
        guard let url = URL(string: pathString) else {
            completion(false)
            return
        }
        
        let parameters: [String: String] = [
            "session_id": sessiondID
        ]
        
        AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: ResponseDeletingSessionID.self,
                               decoder: decoder()) { (response) in
                switch response.result {
                case .success(let responseModel):
                    guard let isSessionIdDeleted = responseModel.success else { return }
                    completion(isSessionIdDeleted)
                case .failure(let error):
                    completion(false)
                    print(error.localizedDescription)
                }
            }
    }
}
