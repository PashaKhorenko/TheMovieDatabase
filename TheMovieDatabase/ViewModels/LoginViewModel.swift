//
//  LoginViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 19.01.2023.
//

import UIKit

class LoginViewModel: LoginViewModelProtocol {
    
    let networkManager: LoginNetworkManagerProtocol?
    let storageManager: StorageProtocol?
    
    init(networkManager: LoginNetworkManagerProtocol?, storageManager: StorageProtocol?) {
        self.networkManager = networkManager
        self.storageManager = storageManager
    }
    
    var requestToken: Dynamic<String?> = Dynamic(nil)
    var isValidUser: Dynamic<Bool?> = Dynamic(nil)
    var sessionId: Dynamic<String?> = Dynamic(nil)
    var accountDetails: Dynamic<User?> = Dynamic(nil)
    
    func getValidText(_ text: String) -> String {
        let trimmedString = text.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }
    
    func fetchRequestToken() {
        networkManager?.createNewToken { [weak self] token in
            self?.requestToken.value = token
        }
    }
    
    func validateUser(withName name: String, password: String) {
        guard let requestTokenOptional = requestToken.value,
            let requestToken = requestTokenOptional else { return }
        
        networkManager?.validateUser(withName: name,
                                    password: password,
                                    forToken: requestToken) { [weak self] isValid in
            self?.isValidUser.value = isValid
        }
    }
    
    func featchSessionID() {
        guard let requestTokenOptional = requestToken.value,
              let requestToken = requestTokenOptional,
              let isValidUserOptional = isValidUser.value,
              let isValidUser = isValidUserOptional else { return }
        
        if isValidUser {
            networkManager?.makeSession(withToken: requestToken) { id in
                self.sessionId.value = id
            }
        }
    }
    
    func saveSessionID() {
        guard let idOptional = self.sessionId.value,
              let id = idOptional else { return }
        
        self.storageManager?.saveSessionIDToStorage(id)
    }
    
    
    func featchAccountDetails() {
        guard let idOptional = self.sessionId.value,
              let id = idOptional else { return }
        networkManager?.downloadAccountDetails(sessionID: id) { accountDetails in
            self.accountDetails.value = accountDetails
        }
    }
    
    func saveAccountDetails() {
        guard let accountDetailsOptional = self.accountDetails.value,
              let accountDetails = accountDetailsOptional else { return }
        
        self.storageManager?.saveAccountDetailsToStorage(accountDetails)
    }
    
    func loginToTheAccount() {
        guard let scene = UIApplication.shared.connectedScenes.first else { return }
        print("Got to scene")
        
        guard let sceneDelegate: SceneDelegate = scene.delegate as? SceneDelegate else { return }
        print("Got to sceneDelegate")
        
        guard let window = sceneDelegate.window else { return }
        print("Got to window")
        
        window.rootViewController = MainTabBarController()
        print("Changed rootViewController to MainTabBarController")
    }
}
