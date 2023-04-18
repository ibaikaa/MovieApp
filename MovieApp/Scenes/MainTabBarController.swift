//
//  MainTabBarController.swift
//  MovieApp
//
//  Created by ibaikaa on 17/4/23.
//

import UIKit

/// Класс  `MainTabBarController` – кастомный `UITabBarController` для проекта.
final class MainTabBarController: UITabBarController {
    
    /// Метод, который создает объект класса `UIViewController` с соответсвующими настройками для `tabBarItem`.
    private func generateVC(
        viewController: UIViewController,
        title: String,
        image: UIImage?,
        selectedImage: UIImage?
    ) -> UIViewController {
        /// Создание `UITabBarItem`
        let tabBarItem = UITabBarItem(
            title: title,
            image: image,
            selectedImage: selectedImage
        )
      
        let vc = setupNavigationController(
            for: viewController,
            title: title,
            tabBarItem: tabBarItem
        )
        
        return vc
    }
    
    
    /// Метод для создания `UINavigatonController'а` для `VC` с определенными настройками UI.
    private func setupNavigationController(
        for viewController: UIViewController,
        title: String,
        tabBarItem: UITabBarItem
    ) -> UINavigationController {
        viewController.view.backgroundColor = .viewBackgroundColor
        viewController.title = title
        
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        
        navigationController.tabBarItem = tabBarItem
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        return navigationController
    }

    /// Метод, который настраивает `viewControllers` для `UITabBarController'а`
    /// и задает, что по умолчанию выбранный элемент будет первым (экран Главная).
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: MovieListViewController(),
                title: "Main",
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house.fill")
            ),
            generateVC(
                viewController: FavoriteMoviesViewController(),
                title: "Favorites",
                image: UIImage(systemName: "heart"),
                selectedImage: UIImage(systemName: "heart.fill")
            )
        ]
        
        selectedIndex = 0
    }
    
    private func setTabBarTrans() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
    }
    
    /// Метод настройки дизайна `UITabBar'а`.
    private func setTabBarAppearance() {
        tabBar.backgroundColor = .tabBarBackgroundColor
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
        setTabBarTrans()
    }
    
}



