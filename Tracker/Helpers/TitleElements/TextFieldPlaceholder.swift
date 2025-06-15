//
//  TextFieldPlaceholder.swift
//  Tracker
//
//  Created by Алина on 04.05.2025.
//
import Foundation

enum TextFieldPlaceholder {
    case trackerName
    case categoryName
    case schedule
    case search
    case custom(String)
    
    var text: String {
        switch self {
            case .trackerName:
                return NSLocalizedString("placeholder.trackerName", comment: "")
            case .categoryName:
                return NSLocalizedString("placeholder.categoryName", comment: "")
            case .schedule:
                return NSLocalizedString("placeholder.schedule", comment: "")
            case .search:
                return NSLocalizedString("placeholder.search", comment: "")
            case .custom(let str):
                return str
        }
    }
}
