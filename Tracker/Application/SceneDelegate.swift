//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Алина on 19.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        if OnBoardingStorage.isOnboardingCompleted {
            window?.rootViewController = MainTabBarController()
        } else {
            window?.rootViewController = OnboardingViewController()
        }
        
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
