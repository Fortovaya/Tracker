//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Алина on 28.05.2025.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    //MARK: - Delegate
    weak var delegate: TrackerCategoryStoreDelegate?
    
    //MARK: - Public variables
    var fetchedCategories: [TrackerCategory] {
        guard let objects = fetchedResultsController?.fetchedObjects else {
            return []
        }
        return objects.compactMap { try? decodeTrackerCategory(from: $0)}
    }
    
    var fetchedCategoryTitles: [String] {
        return fetchedCategories.map { $0.title }
    }
    
    //MARK: - Private variables:
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerCategoryStoreUpdate.Move>?
    
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    
    //MARK: - init
    convenience override init() {
        let context: NSManagedObjectContext
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            context = delegate.persistentContainer.viewContext
        } else {
            assertionFailure("⚠️ Не удалось получить AppDelegate, используем новый NSManagedObjectContext")
            context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        }
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext){
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    //MARK: - Private Methods
    private func setupFetchedResultsController() {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(TrackerCategoryCoreData.title), ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        controller.delegate = self
        self.fetchedResultsController = controller
        
        do {
            try controller.performFetch()
        } catch {
            assertionFailure("❌ Не удалось выполнить fetch для TrackerCategoryCoreData: \(error)")
        }
    }
    
    func addNewTrackerCategoryCoreData(_ trackerCategory: TrackerCategory, for trackerCoreData: TrackerCoreData) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        updateTrackerCategoryCoreData(trackerCategoryCoreData, with: trackerCategory, trackerCoreData: trackerCoreData)
        try context.save()
    }
    
    func updateTrackerCategoryCoreData(_ trackerCategoryCoreData: TrackerCategoryCoreData, with category: TrackerCategory,
                                       trackerCoreData: TrackerCoreData) {
        trackerCategoryCoreData.title = category.title
        trackerCategoryCoreData.addToTrackers(trackerCoreData)
    }
    
    func createCategory(title: String) throws {
        let coreData = TrackerCategoryCoreData(context: context)
        coreData.title = title
        try context.save()
    }
    
    func deleteCategory(withTitle title: String) throws {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        let results = try context.fetch(request)
        for obj in results {
            context.delete(obj)
        }
        try context.save()
    }
    
    func allTitleCategories() -> [String] {
        return fetchedCategoryTitles
    }
    
    private func decodeTrackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title else {
            throw TrackerCategoryError.decodingErrorInvalidIdTitle
        }
        guard let rawTrackers = trackerCategoryCoreData.trackers else {
            throw TrackerCategoryError.decodingErrorInvalidTrackers
        }
        let decodedTrackers: [Tracker] = rawTrackers.compactMap { anyElement in
            guard let singleTrackerCoreData = anyElement as? TrackerCoreData else {
                return nil
            }
            return try? trackerStore.decodeTracker(from: singleTrackerCoreData)
        }
        
        return TrackerCategory(title: title, trackers: decodedTrackers)
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerCategoryStoreUpdate.Move>()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard
            let inserted = insertedIndexes,
            let deleted = deletedIndexes,
            let updated = updatedIndexes,
            let moved = movedIndexes
        else { return }
        
        delegate?.store(self, didUpdate: TrackerCategoryStoreUpdate(
            insertedIndexes: inserted,
            deletedIndexes: deleted,
            updatedIndexes: updated,
            movedIndexes: moved
        ))
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
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
