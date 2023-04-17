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
        image: UIImage?
    ) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    /// Метод, который настраивает `viewControllers` для `UITabBarController'а`
    ///  и задает, что по умолчанию выбранный элемент будет первым (экран Главная).
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: HomeViewController(),
                title: "Main",
                image: UIImage(systemName: "house.fill")
            ),
            generateVC(
                viewController: FavoriteMoviesViewController(),
                title: "Favorites",
                image: UIImage(systemName: "heart.fill")
            ),
            generateVC(
                viewController: SettingsViewController(),
                title: "Settings",
                image: UIImage(systemName: "slider.horizontal.3")
            )
        ]
        
        selectedIndex = 0
    }
    
    /// Метод, необходимый для того, чтоб `UITabBar` был прозрачным.
    private func setTabBarTransparent() {
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .clear
        tabBar.shadowImage = UIImage()
    }
    
    /// Метод настройки дизайна `UITabBar'а`.
    private func setTabBarAppearance() {
        tabBar.barStyle = .default
        
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height
            ),
            cornerRadius: height / 2
        )
        
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.mainWhite.cgColor
        
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
    }
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarAppearance()
        setTabBarTransparent()
    }
    
}



