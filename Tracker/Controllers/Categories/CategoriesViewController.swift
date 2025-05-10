//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Алина on 11.05.2025.
//
import UIKit
//TO DO:
final class CategoriesViewController: BaseController {
    
    private lazy var selectCategoryButton = MakeSelectCategoryButton(
        title: "Домашний уют",
        height: 75,
        target: self,
        action: #selector(didTapSelectCategory)
    )
    
    
    private lazy var addNewCategoriesButton = BaseButton(title: .addCategory,
                                               target: self,
                                               action: #selector(didTapNewCategories))
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setCenteredInlineTitle(title: .category)
        configurationCategoriesVC()
    }
    
    private func configurationCategoriesVC(){
        view.addSubviews([addNewCategoriesButton, selectCategoryButton])
        
        
        NSLayoutConstraint.activate([
            addNewCategoriesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addNewCategoriesButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addNewCategoriesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            selectCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            selectCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            selectCategoryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            selectCategoryButton.heightAnchor.constraint(equalToConstant: 75)
            
        ])
    }
    
    @objc private func didTapSelectCategory(){
        selectCategoryButton.isImageHidden.toggle()
    }
    
    @objc private func didTapNewCategories(){
    }
}
