//
//  UIView+Extensions.swift
//  Tracker
//
//  Created by Алина on 10.05.2025.
//
import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
}
