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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        //nothing
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        //nothing
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        //nothing
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        //nothing
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        //nothing
    }
}

