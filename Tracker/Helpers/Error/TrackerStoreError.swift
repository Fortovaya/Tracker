//
//  TrackerStoreError.swift
//  Tracker
//
//  Created by Алина on 01.06.2025.
//

enum TrackerStoreError: Error {
    case decodingErrorInvalidIdTrackers
    case decodingErrorInvalidNameTrackers
    case decodingErrorInvalidColorHex
    case decodingErrorInvalidEmojies
    case decodingErrorInvalidScheduleTrackers
}
