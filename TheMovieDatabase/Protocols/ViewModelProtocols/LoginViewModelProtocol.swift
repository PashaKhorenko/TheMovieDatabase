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
    
    var requestToken: Dynamic<String?> { get set }
    var isValidUser: Dynamic<Bool?> { get set }
    var sessionId: Dynamic<String?> { get set }
    var accountDetails: Dynamic<User?> { get set }
    
    func getValidText(_ text: String) -> String
    
    func fetchRequestToken()
    
    func validateUser(withName name: String,
                      password: String)
    
    func featchSessionID()
    func featchAccountDetails()
    
    func saveSessionID()
    func saveAccountDetails(_ user: User)
    
    func loginToTheAccount()
}
