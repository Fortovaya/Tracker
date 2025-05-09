//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Алина on 20.04.2025.
//
import UIKit

final class TrackerViewController: BaseController {
    
    //MARK: Private variable
    private var categories: [TrackerCategory] = [] // список категорий и трекеров
    private var completedTrackers: [TrackerRecord] = [] // выполненные трекеры (после нажатия на +, добавляется запись в completedTrackers
    private var newTrackers: [Tracker] = []
    private var currentDate: Date?
    
    private lazy var dizzyImage: UIImageView = {
        let image = UIImage(named: Resources.ImageNames.dizzy.imageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = false
        return imageView
    }()
    
    private lazy var dizzyLabel: UILabel = {
        let label = UILabel()
        label.text = Resources.Labels.dizzyLabel.text
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
        button.setImage(UIImage(named: Resources.ButtonIcons.plus.imageName), for: .normal)
        button.tintColor = .ypBlack
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
        searchController.searchResultsUpdater = self
        
        let searchTextField = searchController.searchBar.searchTextField
        
        searchTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        searchTextField.textColor = .ypBlack
        
        searchTextField.leftView?.tintColor = .ypGray
        
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.masksToBounds = true
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: Resources.Labels.searchPlaceholder.text,
            attributes: [
                .foregroundColor: UIColor.ypGray,
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        
        return searchController
    }()
    
    private lazy var trackerCollectionMain: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopNavigationBar()
        configureConstraintsTrackerViewController()
    }
    
    //MARK: Private method
    private func configureConstraintsTrackerViewController() {
        view.addSubview(dizzyStackView)
        view.addSubview(trackerCollectionMain)
        
        [dizzyStackView, dizzyImage, trackerCollectionMain].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            dizzyImage.widthAnchor.constraint(equalToConstant: 80),
            dizzyImage.heightAnchor.constraint(equalToConstant: 80),
            
            dizzyStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dizzyStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dizzyStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -304),
            
            trackerCollectionMain.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerCollectionMain.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerCollectionMain.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupTopNavigationBar() {
        title = Resources.ScreenTitles.tracker.text
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        let leftItemButton = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.leftBarButtonItem = leftItemButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        let rightItemButton = UIBarButtonItem(customView: dateButton)
        navigationItem.rightBarButtonItem = rightItemButton
    }
    
    @objc private func tapAddTrackerButton() {
        presentPageSheet(viewController: TrackerTypeViewController())
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

extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TO DO:
    }
}

extension TrackerViewController: FooterViewDelegate {
    func footerViewDidTapPlusButton(_ footerView: FooterView) {
        //TO DO:
    }
}

