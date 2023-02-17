//
//  LoginViewModelProtocol.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.02.2023.
//

import Foundation

protocol LoginViewModelProtocol {
    
    var networkManager: LoginNetworkManagerProtocol? { get }
    var storageManager: StorageProtocol? { get }
    
    func getValidText(_ text: String) -> String
    
    func fetchRequestToken(_ completionHandler: @escaping () -> ())
    
    func validateUser(withName name: String,
                      password: String,
                      _ completionHandler: @escaping (Bool) -> ())
    
    func featchSessionID(_ completionHandler: @escaping (String) -> ())
    func featchAccountDetails(_ sessionID: String, _ completionHandler: @escaping (User) -> ())
    
    func saveSessionID(_ id: String)
    func saveAccountDetails(_ user: User)
    
    func loginToTheAccount()
}
