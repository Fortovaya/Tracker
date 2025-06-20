//
//  StatisticsDataStoreDelegate.swift
//  Tracker
//
//  Created by Алина on 19.06.2025.
//

protocol StatisticsDataStoreDelegate: AnyObject {
    func dataStore(_ store: StatisticsDataStore, didUpdate stats: Statistics?)
}
