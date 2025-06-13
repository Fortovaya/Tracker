//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Алина on 11.05.2025.
//
import UIKit

final class CategoriesViewController: BaseController {
    
    //MARK: - Delegate
    weak var delegate: CategoriesVCDelegate?
    
    var isImageInitiallyHidden: Bool = true
    var initialSelectedCategory: String?
    
    private var categories: [String] = [] {
        didSet {
            tableView.reloadData()
            updatePlaceholderVisibility()
        }
    }
    
    private var selectedIndex: Int? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let store = TrackerCategoryStore()
    
    //MARK: - Private lazy var
    private lazy var addNewCategoriesButton = BaseButton(title: .addCategory,
                                                         target: self,
                                                         action: #selector(didTapNewCategoriesButton))
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.isOpaque = true
        tableView.clearsContextBeforeDrawing = true
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.separatorColor = .ypGray
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(
            top: 0, left: 16, bottom: 0, right: 16)
        tableView.isEditing = false
        tableView.allowsSelection = true
        tableView.backgroundColor = .clear
        
        tableView.register(CategoriesCell.self, forCellReuseIdentifier: CategoriesCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var categoryDizzyImage: UIImageView = {
        let image = UIImage(named: Resources.ImageNames.dizzy.imageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = false
        return imageView
    }()
    
    private lazy var categoryDizzyLabel: UILabel = {
        let label = UILabel()
        label.text = Resources.Labels.categoryDizzyLabel.text
        label.textColor = .ypBlack
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var categoryDizzyStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [categoryDizzyImage, categoryDizzyLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.isHidden = false
        return stack
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        setCenteredInlineTitle(title: .category)
        configurationCategoriesVC()
        loadCategoriesFromStore()
        store.delegate = self
        initialCheckmark()
    }
    
    //MARK: - Private Method
    private func configurationCategoriesVC(){
        view.addSubviews([addNewCategoriesButton, tableView, categoryDizzyStackView])
        [addNewCategoriesButton, tableView, categoryDizzyStackView].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            addNewCategoriesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addNewCategoriesButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addNewCategoriesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: addNewCategoriesButton.topAnchor, constant: -114),
            
            categoryDizzyImage.widthAnchor.constraint(equalToConstant: 80),
            categoryDizzyImage.heightAnchor.constraint(equalToConstant: 80),
            
            categoryDizzyStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 232),
            categoryDizzyStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryDizzyStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility(){
        let hasItems = !categories.isEmpty
        categoryDizzyStackView.isHidden = hasItems
        tableView.isHidden = !hasItems
    }
    
    private func loadCategoriesFromStore() {
        categories = store.allTitleCategories()
    }
    
    private func initialCheckmark(){
        if let initial = initialSelectedCategory,
           let idx = categories.firstIndex(of: initial) {
            selectedIndex = idx
        }
    }
    
    // MARK: - Action
    @objc private func didTapNewCategoriesButton(){
        let addNewCategoriesViewController = AddNewCategoriesViewController()
        presentPageSheet(viewController: addNewCategoriesViewController)
    }
}

//MARK: - UITableViewDataSource
extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesCell.reuseIdentifier, for: indexPath) as? CategoriesCell else {
            return UITableViewCell()
        }
        cell.categoryName = categories[indexPath.row]
        let show = (indexPath.row == selectedIndex)
        cell.configureCell(showCheckmark: show)
        return cell
    }
}
//MARK: - UITableViewDelegate
extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        let title = categories[indexPath.row]
        let isHidden = false
        delegate?.categoriesViewController(self, didSelectCategory: title, isImageHidden: isHidden)
        dismiss(animated: true)
    }
}

extension CategoriesViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        DispatchQueue.main.async { self.loadCategoriesFromStore() }
    }
}
