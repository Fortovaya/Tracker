//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Алина on 28.05.2025.
//

import UIKit
import CoreData

final class TrackerRecordStore {
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
    
    func addNewTrackerRecordCoreData(_ trackerRecord: TrackerRecord, for trackerCoreData: TrackerCoreData) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        updateTrackerRecordCoreData(trackerRecordCoreData, with: trackerRecord, trackerCoreData: trackerCoreData)
        try context.save()
    }
    
    func updateTrackerRecordCoreData(_ trackerRecordCoreData: TrackerRecordCoreData, with mix: TrackerRecord,
                                     trackerCoreData: TrackerCoreData){
        trackerRecordCoreData.date = mix.date
        trackerRecordCoreData.id = mix.trackerId
        trackerRecordCoreData.trackerId = trackerCoreData
    }
}
