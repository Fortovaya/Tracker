//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Алина on 28.05.2025.
//

import UIKit
import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    
    convenience init?() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("❌ Не удалось получить AppDelegate")
            return nil
        }
        
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext){
        self.context = context
    }
    
    func addNewTrackerCategoryCoreData(_ trackerCategory: TrackerCategory, for trackerCoreData: TrackerCoreData) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        updateTrackerCategoryCoreData(trackerCategoryCoreData, with: trackerCategory, trackerCoreData: trackerCoreData)
        try context.save()
    }
    
    func updateTrackerCategoryCoreData(_ trackerCategoryCoreData: TrackerCategoryCoreData, with mix: TrackerCategory,
                                       trackerCoreData: TrackerCoreData) {
        trackerCategoryCoreData.title = mix.title
        trackerCategoryCoreData.addToTrackers(trackerCoreData)
    }
}
