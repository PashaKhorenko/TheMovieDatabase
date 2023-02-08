//
//  MainTabBarController.swift
//  TheMovieDatabase
//
//  Created by Паша Хоренко on 17.01.2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateTabBar()
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(HomeViewController(),
                       title: "Home",
                       image: UIImage(systemName: "house.fill")),
            generateVC(SearchViewController(),
                       title: "Search",
                       image: UIImage(systemName: "magnifyingglass")),
            generateVC(FavoritesViewController(),
                       title: "Favorites",
                       image: UIImage(systemName: "star.fill")),
            generateVC(SettingsViewController(),
                       title: "Settings",
                       image: UIImage(systemName: "gear"))
        ]
        
        UITabBar.appearance().tintColor = .systemIndigo
    }
    
    private func generateVC(_ viewController: UIViewController, title: String, image: UIImage?) -> UINavigationController {
        
        viewController.navigationItem.title = title
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        
        let navigationVC = UINavigationController(rootViewController: viewController)
        
        return navigationVC
    }

}
