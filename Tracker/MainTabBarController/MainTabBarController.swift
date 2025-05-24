//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Алина on 19.04.2025.
//
import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Enum
    private enum Tab: Int {
        case trackers = 0
        case statistics = 1
        
        var title: Resources.TitleTabBarItem {
            switch self {
                case .trackers: return .trackers
                case .statistics: return .statistics
            }
        }
        
        var imageName: Resources.ButtonIcons {
            switch self {
                case .trackers: return .trackersTabBar
                case .statistics: return .statisticsTabBar
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        viewControllers = [
            makeTab(for: .trackers),
            makeTab(for: .statistics)
        ]
        
        setupMainTabBarController()
    }
    
    // MARK: Private Methods
    private func setupMainTabBarController() {
        view.backgroundColor = .ypWhite
        tabBar.isTranslucent = false
        tabBar.tintColor = .ypBlue
        tabBar.unselectedItemTintColor = .ypGray
        tabBar.layer.borderColor = UIColor.ypGray.cgColor
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.masksToBounds = true
    }
    
    private func makeTab(for tab: Tab) -> UINavigationController {
        let viewController = tab.viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.tabBarItem = UITabBarItem(
            title: tab.title.text,
            image: UIImage(named: tab.imageName.imageName),
            selectedImage: UIImage(named: tab.imageName.imageName)
        )
        
        navigationController.tabBarItem.tag = tab.rawValue
        navigationController.navigationBar.isHidden = false
        return navigationController
    }
}
