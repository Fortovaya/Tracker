//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by Алина on 11.05.2025.
//
import Foundation

protocol TrackerCellDelegate: AnyObject {
    func trackerCellDidTapPlus(_ cell: TrackerCell, id: UUID)
    func completedDaysCount(for trackerId: UUID) -> Int
    func isTrackerCompleted(for trackerId: UUID, on date: Date) -> Bool
    func dayString(for count: Int) -> String
}
