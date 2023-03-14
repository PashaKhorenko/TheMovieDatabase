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
        self.storageManager?.saveSessionType(.authorized)
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
        // check if the current scene is correctly defined
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            print("Could not find current window scene")
            return
        }
        
        // get the current scene delegate
        guard let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            print("Could not get scene delegate")
            return
        }
        
        // create a new MainTabBarController
        let mainTabBarController = MainTabBarController()
        
        // perform root controller change on main thread
        DispatchQueue.main.async {
            sceneDelegate.window?.rootViewController = mainTabBarController
        }
    }
}
