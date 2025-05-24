//
//  DateFormatter+Extensions.swift
//  Tracker
//
//  Created by Алина on 20.04.2025.
//
import UIKit

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
