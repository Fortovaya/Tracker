//
//  Tracker.swift
//  Tracker
//
//  Created by Алина on 29.04.2025.
//
import UIKit

struct Tracker {
    typealias Identifier = UUID
    
    let idTrackers: Identifier
    let nameTrackers: String
    let colorTrackers: UIColor
    let emojiTrackers: String
    let scheduleTrackers: Set<WeekDay>
}
