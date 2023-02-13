//
//  LoginViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 19.01.2023.
//

import UIKit

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
    
    func validateUser(withName name: String, password: String, _ completionHandler: @escaping (Bool) -> ()) {
        guard let requestToken else { return }
        networkManager.validateUser(withName: name,
                                    password: password,
                                    forToken: requestToken) { [weak self] isValid in
            self?.validUser = isValid
            completionHandler(isValid)
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
    
    
    func featchAccountDetails(_ sessionID: String, _ completionHandler: @escaping (User) -> ()) {
        networkManager.downloadAccountDetails(sessionID: sessionID) { accountDetails in
            completionHandler(accountDetails)
        }
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
