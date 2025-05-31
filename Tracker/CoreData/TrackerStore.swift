//
//  TrackerStore.swift
//  Tracker
//
//  Created by Алина on 28.05.2025.
//

import UIKit
import CoreData

final class TrackerStore {
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    private let daysValueTransformer = DaysValueTransformer()
    
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
    
    func addNewEmoji(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateTrackerCoreData(trackerCoreData, with: tracker)
        try context.save()
    }
    
    func updateTrackerCoreData(_ trackerCoreData: TrackerCoreData, with mix: Tracker){
        trackerCoreData.idTrackers = mix.idTrackers
        trackerCoreData.nameTrackers = mix.nameTrackers
        trackerCoreData.colorTrackers = uiColorMarshalling.hexString(from: mix.colorTrackers)
        trackerCoreData.emojiTrackers = mix.emojiTrackers
        
        if let data = daysValueTransformer.transformedValue(mix.scheduleTrackers) as? NSObject {
            trackerCoreData.scheduleTrackers = data
        } else {
            print("❌ Ошибка сериализации scheduleTrackers")
        }
    }
}
