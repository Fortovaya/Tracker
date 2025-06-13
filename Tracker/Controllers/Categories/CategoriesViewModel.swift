//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Алина on 13.06.2025.
//

import UIKit

final class CategoriesViewModel {
    
    var onCategoriesChanged: (() -> Void)?
    
    private(set) var categories: [CategoryCellViewModel] = [] {
        didSet { onCategoriesChanged?() }
    }
    
    private let store: TrackerCategoryStore
    
    var initialSelectedCategory: String?
    
    
    init(store: TrackerCategoryStore = TrackerCategoryStore()) {
        self.store = store
        self.store.delegate = self
        loadCategoriesFromStore()
    }
    
    func loadCategoriesFromStore() {
        let titles = store.allTitleCategories()
        categories = titles.map { title in
            CategoryCellViewModel(title: title, isSelected: title == initialSelectedCategory)
        }
    }
    
    func selectCategory(at index: Int) {
        for i in categories.indices {
            categories[i].isSelected = (i == index)
        }
    }
}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        DispatchQueue.main.async {
            self.loadCategoriesFromStore()
        }
    }
}
