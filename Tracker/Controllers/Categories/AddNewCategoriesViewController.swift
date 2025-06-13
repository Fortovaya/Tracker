//
//  AddNewCategoriesViewController.swift
//  Tracker
//
//  Created by Алина on 13.06.2025.
//

import UIKit

final class AddNewCategoriesViewController: BaseController {
    
    //MARK: - Private variables
    private lazy var saveCategoriesButton = BaseButton(title: .done,
                                                       backgroundColor: .ypGray,
                                                       target: self,
                                                       action: #selector(didTapSaveCategoriesButton))
    private var newCategoryText: String = "" {
        didSet {
            updateSaveButtonState()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = true
        tableView.isOpaque = true
        tableView.clearsContextBeforeDrawing = true
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.isEditing = false
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(AddNewCategoryCell.self, forCellReuseIdentifier: AddNewCategoryCell.reuseIdentifier)
        return tableView
    }()
    
    private let categoryStore = TrackerCategoryStore()
    
    //MARK: - Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        setCenteredInlineTitle(title: .newCategory)
        configurationAddNewCategoriesViewController()
        updateSaveButtonState()
    }
    
    //MARK: - Private Methods
    private func configurationAddNewCategoriesViewController(){
        view.addSubviews([saveCategoriesButton, tableView])
        [saveCategoriesButton, tableView].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            saveCategoriesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            saveCategoriesButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveCategoriesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: saveCategoriesButton.topAnchor, constant: -400)
        ])
        saveCategoriesButton.isEnabled = false
    }
    
    private func updateSaveButtonState() {
        let hasText = !newCategoryText.trimmingCharacters(in: .whitespaces).isEmpty
        saveCategoriesButton.backgroundColor = hasText ? .ypBlack : .ypGray
        saveCategoriesButton.isEnabled = hasText
    }
    
    //MARK: - Action
    @objc private func didTapSaveCategoriesButton(){
        do {
            try categoryStore.createCategory(title: newCategoryText)
            dismiss(animated: true)
        } catch {
            assertionFailure("❌ Ошибка создания категории: \(error)")
        }
    }
}

//MARK: - UITableViewDataSource
extension AddNewCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddNewCategoryCell.reuseIdentifier, for: indexPath)
                as? AddNewCategoryCell else { return UITableViewCell() }
        
        cell.onTextChange = { [weak self ] text in
            guard let self = self else { return }
            self.newCategoryText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return cell
    }
}
//MARK: - UITableViewDelegate
extension AddNewCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
