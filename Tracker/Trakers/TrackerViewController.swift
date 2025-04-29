//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Алина on 20.04.2025.
//
import UIKit

final class TrackerViewController: UIViewController {
    //MARK: Private variable
    private var categories: [TrackerCategory] = [] // список категорий и трекеров
    private var completedTrackers: [TrackerRecord] = [] // выполненные трекеры (после нажатия на +, добавляется запись в completedTrackers
    private var newTrackers: [Tracker] = []
    
    private lazy var dizzyImage: UIImageView = {
        let image = UIImage(named: "dizzy")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = false
        return imageView
    }()
    
    private lazy var dizzyLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var dizzyStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dizzyImage, dizzyLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.isHidden = false
        return stack
    }()
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.addTarget(self, action: #selector(tapAddTrackerButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(DateFormatter.dateFormatter.string(from: Date()), for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .ypDatePicker
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(tapDateButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 77),
            button.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        return button
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        let searchTextField = searchController.searchBar.searchTextField
        
        searchTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        searchTextField.textColor = .ypBlack
        
        searchTextField.leftView?.tintColor = .ypGray
        
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.masksToBounds = true
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                .foregroundColor: UIColor.ypGray,
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        
        return searchController
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureConstraintsTrackerViewController()
        hideKeyboardWhenTappedAround()
        setupTopNavigationBar()
        
        definesPresentationContext = true
    }
    
    //MARK: Private method
    private func configureConstraintsTrackerViewController() {
        view.addSubview(dizzyStackView)
        
        [dizzyStackView, dizzyImage].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            dizzyImage.widthAnchor.constraint(equalToConstant: 80),
            dizzyImage.heightAnchor.constraint(equalToConstant: 80),
            
            dizzyStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dizzyStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dizzyStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -304)
        ])
    }
    
    private func setupTopNavigationBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let leftItemButton = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.leftBarButtonItem = leftItemButton
        
        let rightItemButton = UIBarButtonItem(customView: dateButton)
        navigationItem.rightBarButtonItem = rightItemButton
    }
    
    @objc private func tapAddTrackerButton() {
        // TO DO:
        print("TO DO: tapAddTrackerButton()")
    }
    
    @objc private func tapDateButton() {
        let calendarVC = CalendarViewController()
        calendarVC.modalPresentationStyle = .overCurrentContext
        calendarVC.modalTransitionStyle = .crossDissolve
        
        calendarVC.onDatePicked = { [weak self] selectedDate in
            guard let self = self else { return }
            
            let title = DateFormatter.dateFormatter.string(from: selectedDate)
            self.dateButton.setTitle(title, for: .normal)
            print("Выбрана дата: \(title)")
        }
        present(calendarVC, animated: true)
    }
    
}
