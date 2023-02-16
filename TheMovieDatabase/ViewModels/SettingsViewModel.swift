//
//  SettingsViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 02.02.2023.
//

import UIKit

protocol SettingsViewModelProtocol {
    var storageManeger: StorageProtocol? { get }
    
    func getAccountDetails() -> AccountDetailsRealm?
    func signOutOfTheAccount()
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    internal let storageManeger: StorageProtocol?
    
    init(storageManeger: StorageProtocol?) {
        self.storageManeger = storageManeger
    }
        
    func getAccountDetails() -> AccountDetailsRealm? {
        let accountDetails = storageManeger?.getAccountDetailsFromStorage()
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
