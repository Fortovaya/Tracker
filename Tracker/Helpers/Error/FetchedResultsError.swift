//
//  FetchedResultsError.swift
//  Tracker
//
//  Created by Алина on 07.06.2025.
//

enum FetchedResultsError: Error {
    case missingNewIndexPath
    case missingIndexPath
    case missingOldOrNewIndexPath
    case unknownChangeType
}
