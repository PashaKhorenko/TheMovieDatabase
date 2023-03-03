//
//  SceneDelegate.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 16.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let signUpVM = SignUpViewModel(networkManager: SignUpNetworkManager(),
                                       storageManager: StorageManager())
        let signUpVC = SignUpViewController(viewModel: signUpVM)
        let authNavigationController = UINavigationController(rootViewController: signUpVC)
        window.rootViewController = authNavigationController
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
}
