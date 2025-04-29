//
//  UIViewArray+Extensions.swift
//  Tracker
//
//  Created by Алина on 27.04.2025.
//
import UIKit

extension Array where Element: UIView {
    func disableAutoresizingMask() {
        forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
}
