//
//  TrackerStoreDelegate.swift
//  Tracker
//
//  Created by Алина on 01.06.2025.
//

protocol TrackerStoreDelegate: AnyObject {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate)
}
