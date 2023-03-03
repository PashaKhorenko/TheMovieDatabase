//
//  SettingsViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 02.02.2023.
//

import UIKit

class SettingsViewModel: SettingsViewModelProtocol {
    
    let storageManeger: StorageProtocol?
    
    init(storageManeger: StorageProtocol?) {
        self.storageManeger = storageManeger
    }
        
    func getAccountDetails() -> AccountDetailsRealm? {
        let accountDetails = storageManeger?.getAccountDetailsFromStorage()
        return accountDetails
    }
    
    func signOutOfTheAccount() {
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
        
        // create a authNavigationController with a instance of SignUpViewController
        let signUpVM = SignUpViewModel(networkManager: SignUpNetworkManager(),
                                       storageManager: StorageManager())
        let signUpViewController = SignUpViewController(viewModel: signUpVM)
        let authNavigationController = UINavigationController(rootViewController: signUpViewController)
        
        // perform root controller change on main thread
        DispatchQueue.main.async {
            sceneDelegate.window?.rootViewController = authNavigationController
        }
    }
}
