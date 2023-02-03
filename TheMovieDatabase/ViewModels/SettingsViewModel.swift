//
//  SettingsViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 02.02.2023.
//

import UIKit

class SettingsViewModel {
    
    private let storageManeger = StorageManager()
        
    func getAccountDetails() -> AccountDetailsRealm? {
        let accountDetails = storageManeger.getAccountDetailsFromStorage()
        return accountDetails
    }
    
    func signOutOfTheAccount() {
        guard let scene = UIApplication.shared.connectedScenes.first else { return }
        print("Got to scene")
        
        guard let sceneDelegate: SceneDelegate = scene.delegate as? SceneDelegate else { return }
        print("Got to sceneDelegate")
        
        guard let window = sceneDelegate.window else { return }
        print("Got to window")
        
        window.rootViewController = SignUpViewController()
        print("Changed rootViewController to SignUpViewController")
    }
}
