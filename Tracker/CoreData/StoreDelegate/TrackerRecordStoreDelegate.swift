//
//  TrackerRecordStoreDelegate.swift
//  Tracker
//
//  Created by Алина on 07.06.2025.
//

protocol TrackerRecordStoreDelegate: AnyObject {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate)
}
