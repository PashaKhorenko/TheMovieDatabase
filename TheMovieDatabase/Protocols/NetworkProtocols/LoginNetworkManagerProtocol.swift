//
//  LoginNetworkManagerProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol LoginNetworkManagerProtocol {
    
    func decoder() -> JSONDecoder
    
    func createNewToken(_ completion: @escaping (String) -> Void)
    
    func validateUser(withName name: String,
                      password: String,
                      forToken token: String,
                      _ completion: @escaping (Bool) -> ())
    
    func makeSession(withToken token: String, _ completion: @escaping (String) -> ())
    
    func downloadAccountDetails(sessionID: String, _ completion: @escaping (User) -> ())
}
