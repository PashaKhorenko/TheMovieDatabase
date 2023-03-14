//
//  SignUpViewModel.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 03.03.2023.
//

import UIKit

class SignUpViewModel: SignUpViewModelProtocol {
    
    let networkManager: SignUpNetworkManagerProtocol?
    let storageManager: StorageProtocol?
    
    init(networkManager: SignUpNetworkManagerProtocol?, storageManager: StorageProtocol?) {
        self.networkManager = networkManager
        self.storageManager = storageManager
    }
    
    var guestSessionID: Dynamic<String?> = Dynamic(nil)
    
    func featchGuestSessionID() {
        self.networkManager?.createGuestSessionID() { [weak self] guestSessionID in
            self?.guestSessionID.value = guestSessionID
        }
    }
    
    func saveGuestSessionID() {
        guard let optionalID = self.guestSessionID.value,
              let guestSessionID = optionalID else { return }
        
        self.storageManager?.saveSessionIDToStorage(guestSessionID)
        self.storageManager?.saveSessionType(.guest)
    }
    
    func deleteDataFromStorage() {
        self.storageManager?.deleteAccountDetailsAndSessionId()
        self.storageManager?.deleteSessionTypeFromStorage()
    }
    
    func logInToGuestSession() {
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
