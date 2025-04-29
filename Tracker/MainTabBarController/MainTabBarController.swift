//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Алина on 19.04.2025.
//
import UIKit

final class MainTabBarController: UITabBarController {
    
    private enum Tab: Int {
        case trackers = 0
        case statistics = 1
        
        var title: String {
            switch self {
            case .trackers: return "Трекеры"
            case .statistics: return "Статистика"
            }
        }
        
        var imageName: String {
            switch self {
            case .trackers: return "trackers"
            case .statistics: return "hare"
            }
        }
        
        var viewController: UIViewController {
            switch self {
            case .trackers:
                return TrackerViewController()
            case .statistics:
                return TrackerStatisticsViewController()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            makeTab(for: .trackers),
            makeTab(for: .statistics)
        ]
        
        setupMainTabBarController()
    }
    
    private func setupMainTabBarController() {
        view.backgroundColor = .ypWhite
        tabBar.isTranslucent = false
        tabBar.tintColor = .ypBlue
        tabBar.unselectedItemTintColor = .ypGray
    }
    
    private func makeTab(for tab: Tab) -> UINavigationController {
        let viewController = tab.viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.tabBarItem = UITabBarItem(
            title: tab.title,
            image: UIImage(named: tab.imageName),
            selectedImage: UIImage(named: tab.imageName)
        )
        
        navigationController.tabBarItem.tag = tab.rawValue
        navigationController.navigationBar.isHidden = (viewController is TrackerViewController) ? false : true
        return navigationController
    }
}
