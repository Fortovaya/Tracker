//
//  AppDelegate.swift
//  Tracker
//
//  Created by Алина on 19.04.2025.
//

import UIKit
import CoreData

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        
        DaysValueTransformer.register()
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Не удалось загрузить Core Data store: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    static var viewContext: NSManagedObjectContext {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("❌ Не удалось получить AppDelegate для Core Data")
        }
        return delegate.persistentContainer.viewContext
    }
    
    // MARK: — Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Ошибка сохранения контекста: \(nserror), \(nserror.userInfo)")
        }
    }
}
