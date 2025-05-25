//
//  TrackerStyleCellDelegate.swift
//  Tracker
//
//  Created by Алина on 24.05.2025.
//
import UIKit

protocol TrackerStyleCellDelegate: AnyObject {
    func trackerStyleCollectionServices(_ services: TrackerStyleCollectionServices,
                                        didSelectEmoji: Resources.EmojiImage,
                                        andColor color: UIColor)
}
