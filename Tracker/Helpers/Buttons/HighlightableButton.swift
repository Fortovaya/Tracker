//
//  HighlightableButton.swift
//  Tracker
//
//  Created by Алина on 02.05.2025.
//
import UIKit

class HighlightableButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.5 : 1.0
        }
    }
}
