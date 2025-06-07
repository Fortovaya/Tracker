//
//  Weekday.swift
//  Tracker
//
//  Created by Алина on 29.04.2025.
//
import Foundation

enum WeekDay: Int, CaseIterable, Codable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
    
    static func orderedWeekday(date: Date) -> WeekDay {
        let calendar = Calendar.current
        let gregorianWeekday = calendar.component(.weekday, from: date)
        let rawValue = gregorianWeekday == 1 ? 7 : gregorianWeekday - 1
        guard let weekday = WeekDay(rawValue: rawValue) else {
            let todayComponent = calendar.component(.weekday, from: Date())
            let todayRaw = (todayComponent == 1 ? 7 : todayComponent - 1)
            return WeekDay(rawValue: todayRaw) ?? .monday
        }
        return weekday
    }
    
    var fullName: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
        
    }
    
    var shortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
}
