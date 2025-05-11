//
//  TrackerTypeViewControllerDelegate.swift
//  Tracker
//
//  Created by Алина on 11.05.2025.
//
import Foundation

protocol TrackerTypeViewControllerDelegate: AnyObject {
    func trackerTypeViewController(_ controller: TrackerTypeViewController, didCreate tracker: Tracker, categoryTitle: String)
}
