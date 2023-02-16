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
        let homeVM: HomeViewModelProtocol = HomeViewModel(networkManager: HomeNetworkManager())
        let searchVM: SearchViewModelProtocol = SearchViewModel(networkManeger: SearchNetworkManager())
        let favoriteVM: FavoriteViewModelProtocol = FavoriteViewModel(networkManager: FavoriteNetworkManager(), storageManager: StorageManager())
        let settingsVM: SettingsViewModelProtocol = SettingsViewModel(storageManeger: StorageManager())
        
        viewControllers = [
            generateVC(HomeViewController(viewModel: homeVM),
                       title: "Home",
                       image: UIImage(systemName: "house.fill")),
            generateVC(SearchViewController(viewModel: searchVM),
                       title: "Search",
                       image: UIImage(systemName: "magnifyingglass")),
            generateVC(FavoritesViewController(viewModel: favoriteVM),
                       title: "Favorites",
                       image: UIImage(systemName: "star.fill")),
            generateVC(SettingsViewController(viewModel: settingsVM),
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
