//
//  TrackerCreationMode.swift
//  Tracker
//
//  Created by Алина on 07.06.2025.
//

enum TrackerCreationMode {
    case habit
    case event
    case editHabit(trackerToEdit: Tracker, categoryToEdit: String)
    
    var title: Resources.ScreenTitles {
        switch self {
            case .habit:  return .newHabit
            case .event:  return .newEvents
            case .editHabit: return .editHabit
        }
    }
}
