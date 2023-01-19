//
//  LoginViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 19.01.2023.
//

import Foundation

class LoginViewModel {
    
    private let networkManager = LoginNetworkManager()
    
    private var requestToken: String?
    private var validUser: Bool?
    
    func getValidText(_ text: String) -> String {
        let trimmedString = text.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }
    
    func fetchRequestToken(_ completionHandler: @escaping () -> ()) {
        networkManager.createNewToken { [weak self] token in
            self?.requestToken = token
            completionHandler()
        }
    }
    
    func validateUser(withName name: String, password: String, _ completionHandler: @escaping () -> ()) {
        guard let requestToken else { return }
        networkManager.validateUser(withName: name,
                                    password: password,
                                    forToken: requestToken) { [weak self] isValid in
            self?.validUser = isValid
            completionHandler()
        }
    }
    
    func featchSessionID(_ completionHandler: @escaping (String) -> ()) {
        guard let requestToken, let validUser else { return }
        
        if validUser {
            networkManager.makeSession(withToken: requestToken) { id in
                completionHandler(id)
            }
        }
    }
}
