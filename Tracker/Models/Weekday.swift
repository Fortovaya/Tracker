//
//  Weekday.swift
//  Tracker
//
//  Created by Алина on 29.04.2025.
//

enum Weekday: Int, CaseIterable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var displayName: String {
        switch self {
        case .monday:    return "Пн"
        case .tuesday:   return "Вт"
        case .wednesday: return "Ср"
        case .thursday:  return "Чт"
        case .friday:    return "Пт"
        case .saturday:  return "Сб"
        case .sunday:    return "Вс"
        }
    }
}
