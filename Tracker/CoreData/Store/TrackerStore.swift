//
//  TrackerStore.swift
//  Tracker
//
//  Created by Алина on 28.05.2025.
//

import UIKit
import CoreData

final class TrackerStore: NSObject {
    // MARK: - Delegate
    weak var delegate: TrackerStoreDelegate?
    
    //MARK: - Public variables
    var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController?.fetchedObjects,
            let tracker = try? objects.map({ try self.decodeTracker(from: $0 )})
        else { return [] }
        return tracker
    }
    
    // MARK: - Private variables
    private let context: NSManagedObjectContext
    private let uiColorMarshalling = UIColorMarshalling()
    private let daysValueTransformer = DaysValueTransformer()
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerStoreUpdate.Move>?
    
    // MARK: - init
    convenience override init() {
        let context = AppDelegate.viewContext
        do {
            try self.init(context: context)
        } catch {
            assertionFailure("❌ [TrackerStore \(#function):\(#line)] Couldn't init with context: \(error)")
            try! self.init(context: context)
        }
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.nameTrackers, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    // MARK: - Public Methods
    func addNewTracker(_ tracker: Tracker, categoryTitle: String) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        updateTrackerCoreData(trackerCoreData, with: tracker)
        
        let categoryRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        categoryRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        
        let category: TrackerCategoryCoreData
        if let existingCategory = try context.fetch(categoryRequest).first {
            category = existingCategory
        } else {
            category = TrackerCategoryCoreData(context: context)
            category.title = categoryTitle
        }
        
        trackerCoreData.trackerCategory = category
        category.addToTrackers(trackerCoreData)
        
        try context.save()
    }
    /// поиск трекеров без учета регистра по полю nameTrackers
    func fetchTrackers(withName name: String) throws -> [Tracker] {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nameTrackers CONTAINS[cd] %@", name)
        let results = try context.fetch(fetchRequest)
        return try results.map { try decodeTracker(from: $0) }
    }
    
    func fetchTrackerCoreData(by id: UUID) -> TrackerCoreData? {
        let req: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        req.predicate = NSPredicate(format: "idTrackers == %@", id as CVarArg)
        return (try? context.fetch(req))?.first
    }

    func decodeTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let nameTrackers = trackerCoreData.nameTrackers else {
            throw TrackerStoreError.decodingErrorInvalidNameTrackers
        }
        guard let colorTrackers = trackerCoreData.colorTrackers else {
            throw TrackerStoreError.decodingErrorInvalidColorHex
        }
        guard let emojiTrackers = trackerCoreData.emojiTrackers else {
            throw TrackerStoreError.decodingErrorInvalidEmojies
        }
        guard let idTrackers = trackerCoreData.idTrackers else {
            throw TrackerStoreError.decodingErrorInvalidIdTrackers
        }
        guard let scheduleRaw = trackerCoreData.scheduleTrackers else {
            throw TrackerStoreError.decodingErrorInvalidScheduleTrackers
        }
        
        guard let scheduleTrackers = scheduleRaw as? Set<WeekDay> else {
            throw TrackerStoreError.decodingErrorInvalidScheduleTrackers
        }
        
        return Tracker(idTrackers: idTrackers,
                       nameTrackers: nameTrackers,
                       colorTrackers: uiColorMarshalling.color(from: colorTrackers),
                       emojiTrackers: emojiTrackers,
                       scheduleTrackers: scheduleTrackers
        )
    }
    
    // MARK: - Private Methods
    private func updateTrackerCoreData(_ trackerCoreData: TrackerCoreData, with mix: Tracker){
        trackerCoreData.idTrackers = mix.idTrackers
        trackerCoreData.nameTrackers = mix.nameTrackers
        trackerCoreData.colorTrackers = uiColorMarshalling.hexString(from: mix.colorTrackers)
        trackerCoreData.emojiTrackers = mix.emojiTrackers
        trackerCoreData.scheduleTrackers = mix.scheduleTrackers as NSSet
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerStoreUpdate.Move>()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard
            let inserted = insertedIndexes,
            let deleted = deletedIndexes,
            let updated = updatedIndexes,
            let moved = movedIndexes
        else {
            assertionFailure("❌ Не все значения индексов были инициализированы до controllerDidChangeContent")
            return
        }
        
        delegate?.store(self,didUpdate: TrackerStoreUpdate(
            insertedIndexes: inserted,
            deletedIndexes: deleted,
            updatedIndexes: updated,
            movedIndexes: moved
        ))
        
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
        movedIndexes = nil
    }
    
    func controller( _ controller: NSFetchedResultsController<NSFetchRequestResult>,
                     didChange anObject: Any,at indexPath: IndexPath?, for type: NSFetchedResultsChangeType,
                     newIndexPath: IndexPath?) {
        do {
            switch type {
                case .insert:
                    guard let indexPath = newIndexPath else { throw FetchedResultsError.missingNewIndexPath }
                    insertedIndexes?.insert(indexPath.item)
                case .delete:
                    guard let indexPath = indexPath else { throw FetchedResultsError.missingIndexPath }
                    deletedIndexes?.insert(indexPath.item)
                case .update:
                    guard let indexPath = indexPath else { throw FetchedResultsError.missingIndexPath }
                    updatedIndexes?.insert(indexPath.item)
                case .move:
                    guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {
                        throw FetchedResultsError.missingOldOrNewIndexPath
                    }
                    movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
                @unknown default:
                    throw FetchedResultsError.unknownChangeType
            }
        } catch {
            assertionFailure("❌ [\(Swift.type(of: self)) \(#function):\(#line)] FRC change error: \(error)")
        }
    }
}
