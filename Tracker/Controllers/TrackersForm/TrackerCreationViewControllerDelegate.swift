//
//  TrackerCreationViewControllerDelegate.swift
//  Tracker
//
//  Created by Алина on 11.05.2025.
//
import Foundation

protocol TrackerCreationViewControllerDelegate: AnyObject {
    func trackerCreationViewController(_ controller: NewTrackerViewController,
                                didCreateTracker tracker: Tracker, categoryTitle: String)
}

