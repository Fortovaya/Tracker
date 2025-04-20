//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Алина on 19.04.2025.
//
import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarControllers()
        setupMainTabBarController()
    }
    
    private func configureTabBarControllers(){
        let trackersVC = TrackerViewController()
        let trackersNavVC = UINavigationController(rootViewController: trackersVC)
        trackersNavVC.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackers"), tag: 0)
        
        let trackerStatisticsVC = TrackerStatisticsViewController()
        let trackerStatisticNavVc = UINavigationController(rootViewController: trackerStatisticsVC)
        trackerStatisticNavVc.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "hare"), tag: 1)
        
        viewControllers = [trackersNavVC, trackerStatisticNavVc]
        
        setupNavigationBar(for: trackersNavVC)
        setupNavigationBar(for: trackerStatisticNavVc)
    }
    
    private func setupMainTabBarController(){
        view.backgroundColor = .ypWhite
        tabBar.isTranslucent = false
        tabBar.tintColor = .ypBlue
        tabBar.unselectedItemTintColor = .ypGray
    }
    
    private func setupNavigationBar(for navigationController: UINavigationController){
        navigationController.navigationBar.isHidden = true
    }
}
