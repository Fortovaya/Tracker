//
//  Identifier.swift
//  Tracker
//
//  Created by Алина on 07.05.2025.
//
import Foundation

enum Identifier {
    enum TrackerCollection: String {
        case trackerCell = "TrackerCell"
        case headerView = "HeaderView"
        case footerView = "FooterView"
        
        case trackerStyleCell = "TrackerStyleCell"
        
        var text: String { rawValue }
    }
}
