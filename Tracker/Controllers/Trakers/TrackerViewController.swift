//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Алина on 20.04.2025.
//
import UIKit

final class TrackerViewController: BaseController {
    
    //MARK: Private variable
    private var helper: TrackerCollectionServices?
    let params = GeometricParams(cellCount: 2, cellSpacing: 10, leftInset: 16,
                                 rightInset: 16, topInset: 12, bottomInset: 16)
   
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var newTrackers: [Tracker] = []
    private(set) var currentDate: Date = Date()
   
    private let store = TrackerStore()
    private let categoryStore = TrackerCategoryStore()
    private let recordStore = TrackerRecordStore()
    
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
        layout.estimatedItemSize = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        store.delegate = self
        categoryStore.delegate = self
        recordStore.delegate = self
        
        loadCategories()
        updateCompletedTrackers()
        setupTopNavigationBar()
        setupHelper()
        configureConstraintsTrackerViewController()
        updatePlaceholderVisibility()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategories()
        updateCompletedTrackers()
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
            
            trackerCollectionMain.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerCollectionMain.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackerCollectionMain.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackerCollectionMain.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
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
    
    private func setupHelper(){
        let headerTitles = categories.map { $0.title }
        let footerTitles = categories.map { category in
            let completedDays = category.trackers.reduce(0) { count, tracker in
                completedTrackers.filter { $0.trackerId == tracker.idTrackers }.count
            }
            return "\(completedDays) \(dayString(for: completedDays))"
        }
        helper = TrackerCollectionServices(
            categories: categories,
            params: params,
            collection: trackerCollectionMain,
            headerTitles: headerTitles,
            footerTitles: footerTitles,
            cellDelegate: self
        )
    }
    
    private func updatePlaceholderVisibility(using filteredCategories: [TrackerCategory]){
        let totalTrackers = filteredCategories.reduce(0) { $0 + $1.trackers.count }
        let isEmpty = (totalTrackers == 0)
        dizzyStackView.isHidden = !isEmpty
        trackerCollectionMain.isHidden = isEmpty
    }
    
    private func updatePlaceholderVisibility() {
        updatePlaceholderVisibility(using: categories)
    }
    
    private func refreshUI() {
        setupHelper()
        updatePlaceholderVisibility()
    }
    
    func updateCategories(_ newCategories: [TrackerCategory]) {
        categories = newCategories
        refreshUI()
    }
    
    private func loadCategories() {
        let fetched = categoryStore.fetchedCategories
        let nonEmpty = fetched.filter { !$0.trackers.isEmpty }
        categories = nonEmpty
        refreshUI()
        let weekday = WeekDay.orderedWeekday(date: currentDate)
        filtersTrackers(for: weekday)
    }
    
    private func toggleTrackerCompletion(for trackerId: UUID, on date: Date) {
        let picked = Calendar.current.startOfDay(for: date)
        let today = Calendar.current.startOfDay(for: Date())
        
        guard picked <= today else {
            print("⚠️ Нельзя отметить трекер для будущей даты: \(date)")
            return
        }
        
        do {
            guard let trackerCD = store.fetchTrackerCoreData(by: trackerId) else { return }
            
            if let recordCD = recordStore.fetchRecordCoreData(trackerId: trackerId, on: picked) {
                try recordStore.deleteRecord(recordCD)
                print("❌ Удалили запись выполнения")
            } else {
                let record = TrackerRecord(id: UUID(), trackerId: trackerId, date: picked)
                try recordStore.addNewTrackerRecordCoreData(record, for: trackerCD)
                print("✅ Добавили запись выполнения")
            }
        } catch {
            print("❌ Ошибка при обновлении отметки: \(error)")
        }
    }
    
    private func reloadCell(for cell: TrackerCell) {
        guard let indexPath = trackerCollectionMain.indexPath(for: cell) else { return }
        trackerCollectionMain.reloadItems(at: [indexPath])
    }
    
    private func updateFooters(for date: Date) {
        let newFooters = categories.map { category in
            let completed = category.trackers.filter { tracker in
                completedTrackers.contains {
                    $0.trackerId == tracker.idTrackers &&
                    Calendar.current.isDate($0.date, inSameDayAs: date)
                }
            }.count
            
            return "\(completed) \(dayString(for: completed))"
        }
        
        helper?.updateCategories(with: categories, footerTitles: newFooters)
    }
    
    private func filtersTrackers(for weekDay: WeekDay){
        let filtered = categories.compactMap { category in
            let trackers = category.trackers.filter {
                $0.scheduleTrackers.contains(weekDay)
            }
            
            return trackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackers)
        }
        
        helper?.updateCategories(with: filtered)
        updatePlaceholderVisibility(using: filtered)
    }

    private func updateCompletedTrackers() {
        completedTrackers = recordStore.fetchedRecords
        updateFooters(for: currentDate)
    }
    
    // MARK: - Action
    @objc private func tapAddTrackerButton() {
        let typeVC = TrackerTypeViewController()
        typeVC.habitDelegate = self
        presentPageSheet(viewController: typeVC)
    }
    
    @objc private func tapDateButton() {
        let calendarVC = CalendarViewController()
        calendarVC.modalPresentationStyle = .overCurrentContext
        calendarVC.modalTransitionStyle = .crossDissolve
        
        calendarVC.onDatePicked = { [weak self] selectedDate in
            guard let self = self else { return }
            
            self.currentDate = selectedDate
            let title = DateFormatter.dateFormatter.string(from: selectedDate)
            self.dateButton.setTitle(title, for: .normal)
            
            let weekDay = WeekDay.orderedWeekday(date: selectedDate)
            print("✅ День недели выбранной даты: \(weekDay)")
            
            self.updateFooters(for: selectedDate)
            self.filtersTrackers(for: weekDay)
            print(" Выбрана дата: \(title)")
        }
        present(calendarVC, animated: true)
    }
}

extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TO DO:
    }
}

// MARK: TrackerCreationViewControllerDelegate
extension TrackerViewController: TrackerCreationViewControllerDelegate {
    
    func trackerCreationViewController(_ controller: NewTrackerViewController, didCreateTracker tracker: Tracker,
                                categoryTitle: String) {
        
        if let indexPath = categories.firstIndex(where: { $0.title == categoryTitle }){
            let old = categories[indexPath]
            let updated = TrackerCategory(
                title: old.title,
                trackers: old.trackers + [tracker]
            )
            categories[indexPath] = updated
        } else  {
            let newCat = TrackerCategory(
                title: categoryTitle,
                trackers: [tracker]
            )
            categories.append(newCat)
        }
        newTrackers.append(tracker)
        helper?.updateCategories(with: categories)
        updatePlaceholderVisibility()
    }
}

// MARK: TrackerCellDelegate
extension TrackerViewController: TrackerCellDelegate {
    
    func trackerCellDidTapPlus(_ cell: TrackerCell, id: UUID) {
        let today = currentDate
        toggleTrackerCompletion(for: id, on: today)
        updateFooters(for: today)
        updatePlaceholderVisibility()
        
        if let indexPath = trackerCollectionMain.indexPath(for: cell) {
            trackerCollectionMain.reloadItems(at: [indexPath])
        }
    }
    
    func completedDaysCount(for trackerId: UUID) -> Int {
        completedTrackers.filter { $0.trackerId == trackerId }.count
    }

    func isTrackerCompleted(for trackerId: UUID, on date: Date) -> Bool {
        completedTrackers.contains {
            $0.trackerId == trackerId &&
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }

    func dayString(for count: Int) -> String {
        let lastDigit = count % 10, lastTwoDigits = count % 100
        if lastDigit == 1 && lastTwoDigits != 11 { return "день" }
        if (2...4).contains(lastDigit) && !(12...14).contains(lastTwoDigits) { return "дня" }
        return "дней"
    }
}

extension TrackerViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        DispatchQueue.main.async { self.loadCategories() }
    }
}

extension TrackerViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        DispatchQueue.main.async { self.loadCategories() }
    }
}

extension TrackerViewController: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        DispatchQueue.main.async { self.updateCompletedTrackers() }
    }
}
