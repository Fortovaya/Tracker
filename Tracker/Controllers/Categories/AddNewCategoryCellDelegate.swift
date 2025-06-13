//
//  AddNewCategoryCellDelegate.swift
//  Tracker
//
//  Created by Алина on 13.06.2025.
//
import UIKit

protocol AddNewCategoryCellDelegate: AnyObject {
    func addNewCategoryCell(_ cell: AddNewCategoryCell, didUpdateName name: String)
}
