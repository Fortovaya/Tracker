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
        let component = calendar.component(.weekday, from: date)
        return WeekDay(rawValue: component == 1 ? 7 : component - 1)!
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
//оставила метод сортировки на случай если понадобится далее в проекте
extension WeekDay {
    static func orderedString(from selectedDays: Set<WeekDay>) -> String {
         let orderedDays = selectedDays.sorted { $0.rawValue < $1.rawValue }
         return orderedDays.map { $0.shortName }.joined(separator: ", ")
     }
}
