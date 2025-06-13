//
//  CategoriesVCDelegate.swift
//  Tracker
//
//  Created by Алина on 11.05.2025.
//
import Foundation

protocol CategoriesVCDelegate: AnyObject {
    func categoriesViewController(_ controller: CategoriesViewController, didSelectCategory title: String,
                                  isImageHidden: Bool)
}
