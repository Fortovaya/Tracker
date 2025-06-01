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
    
    init(idTrackers: Identifier = UUID(),
         nameTrackers: String,
         colorTrackers: UIColor,
         emojiTrackers: String,
         scheduleTrackers: Set<WeekDay>
    ) {
        self.idTrackers = idTrackers
        self.nameTrackers = nameTrackers
        self.colorTrackers = colorTrackers
        self.emojiTrackers = emojiTrackers
        self.scheduleTrackers = scheduleTrackers
    }
}
