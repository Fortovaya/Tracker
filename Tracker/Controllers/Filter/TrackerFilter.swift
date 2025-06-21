//
//  TrackerFilter.swift
//  Tracker
//
//  Created by Алина on 21.06.2025.
//

enum TrackerFilter {
    case all
    case today
    case completed
    case uncompleted
    
    init?(filterOption: Resources.FilterOption) {
        switch filterOption {
            case .allTrackers: self = .all
            case .todayTrackers: self = .today
            case .completed: self = .completed
            case .uncompleted: self = .uncompleted
        }
    }
}
