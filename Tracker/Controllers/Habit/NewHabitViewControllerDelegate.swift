//
//  NewHabitViewControllerDelegate.swift
//  Tracker
//
//  Created by Алина on 11.05.2025.
//
import Foundation

protocol NewHabitViewControllerDelegate: AnyObject {
    func newHabitViewController(_ controller: NewHabitViewController,
                                didCreateTracker tracker: Tracker, categoryTitle: String)
}

