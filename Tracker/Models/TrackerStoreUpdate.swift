//
//  TrackerStoreUpdate.swift
//  Tracker
//
//  Created by Алина on 01.06.2025.
//

import Foundation

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}
