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
            generateVC(viewController: HomeViewController(),
                       title: "Home",
                       image: UIImage(systemName: "house.fill")),
            generateVC(viewController: SearchViewController(),
                       title: "Search",
                       image: UIImage(systemName: "magnifyingglass")),
            generateVC(viewController: FavoritesViewController(),
                       title: "Favorites",
                       image: UIImage(systemName: "star.fill"))
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UINavigationController {
        
        viewController.navigationItem.title = title
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        
        let navigationVC = UINavigationController(rootViewController: viewController)
        
        return navigationVC
    }

}
