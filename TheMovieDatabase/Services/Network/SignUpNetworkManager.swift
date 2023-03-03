//
//  SignUpNetworkManager.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 03.03.2023.
//

import Foundation
import Alamofire

class SignUpNetworkManager: SignUpNetworkManagerProtocol {
    
    // MARK: Decoder with convertFromSnakeCase
    func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // MARK: - Guest session id
    func createGuestSessionID(_ completion: @escaping (String) -> Void) {
        let url = "\(APIConstants.baseURL)/authentication/guest_session/new?api_key=\(APIConstants.apiKey)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: GuestSession.self, decoder: decoder()) { (response) in
                switch response.result {
                case .success(let responseModel):
                    guard let guestSessionID = responseModel.guestSessionId else {
                        print("Empty data when creating guest session id")
                        return
                    }
                    completion(guestSessionID)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
