//
//  TrackerCategoryStoreDelegate.swift
//  Tracker
//
//  Created by Алина on 07.06.2025.
//

protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate)
}
