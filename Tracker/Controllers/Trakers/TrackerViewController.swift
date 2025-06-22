//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Алина on 20.04.2025.
//
import UIKit
import YandexMobileMetrica

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
    
    private lazy var alertPresenter: AlertPresenterProtocol = AlertPresenter(viewController: self)
    private var currentFilter: TrackerFilter = .all
    
    private var filteredCategories: [TrackerCategory] = []
    private var isSearching = false
    
    private lazy var placeholderView: PlaceholderView = {
        let view = PlaceholderView()
        view.configure(
            image: UIImage(named: Resources.ImageNames.dizzy.imageName),
            text: Resources.Labels.dizzyLabel.text
        )
        view.isHidden = true
        return view
    }()
    
    private lazy var searchService = TrackerSearchService(
        trackerStore: store,
        categoryStore: categoryStore
    )
    
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
        button.setTitleColor(.black, for: .normal)
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
    
    private lazy var filterButton = BaseButton(title: .filters,
                                               backgroundColor: .ypBlue,
                                               titleColor: .white,
                                               height: 50,
                                               target: self,
                                               action: #selector(didTapFilterButton))
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        YMMYandexMetrica.reportEvent("event", parameters: [
            "event": "open",
            "screen": "Main"
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        YMMYandexMetrica.reportEvent("event", parameters: [
            "event": "close",
            "screen": "Main"
        ])
    }
    
    //MARK: Private methods
    private func configureConstraintsTrackerViewController() {
        view.addSubviews([placeholderView,trackerCollectionMain, filterButton])
        [placeholderView, trackerCollectionMain, filterButton].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -304),
            
            trackerCollectionMain.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerCollectionMain.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackerCollectionMain.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackerCollectionMain.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
    
    private func showPlaceholder(_ type: PlaceholderType) {
        placeholderView.configure(image: type.image, text: type.text)
    }
    
    private func updatePlaceholderVisibility(using filteredCategories: [TrackerCategory]){
        let totalTrackers = filteredCategories.reduce(0) { $0 + $1.trackers.count }
        let isEmpty = (totalTrackers == 0)
        placeholderView.isHidden = !isEmpty
        trackerCollectionMain.isHidden = isEmpty
        
        if isEmpty {
            if isSearching || currentFilter != .all {
                showPlaceholder(.noSearchResults)
            } else {
                showPlaceholder(.emptyTrackers)
            }
        }
        
        updateFilterButtonVisibility()
    }
    
    private func updateFilterButtonVisibility() {
        
        guard !isSearching else {
            filterButton.isHidden = true
            return
        }
        
        let hasTrackers = categories.isEmpty
        let shouldShowFilterButton = !hasTrackers || currentFilter != .all
        
        filterButton.isHidden = !shouldShowFilterButton
        let isFilterActive = currentFilter != .all
        filterButton.setTitleColor(isFilterActive ? .ypRed : .white, for: .normal)
    }
    
    private func updatePlaceholderVisibility() {
        let source = isSearching ? filteredCategories : categories
        updatePlaceholderVisibility(using: source)
    }
    
    private func updateHelper() {
        let data = isSearching ? filteredCategories : categories
        
        let headerTitles = data.map { $0.title }
        let footerTitles = data.map { category in
            let completedDays = category.trackers.reduce(0) { count, tracker in
                completedTrackers.filter { $0.trackerId == tracker.idTrackers }.count
            }
            return "\(completedDays) \(dayString(for: completedDays))"
        }
        
        helper = TrackerCollectionServices(
            categories: data,
            params: params,
            collection: trackerCollectionMain,
            headerTitles: headerTitles,
            footerTitles: footerTitles,
            cellDelegate: self
        )
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
        let weekday = WeekDay.orderedWeekday(date: currentDate)
        var allTrackers = store.trackers.filter { $0.scheduleTrackers.contains(weekday) }
        
        if currentFilter != .all {
            switch currentFilter {
                case .completed:
                    allTrackers = allTrackers.filter { tracker in
                        completedTrackers.contains {
                            $0.trackerId == tracker.idTrackers &&
                            Calendar.current.isDate($0.date, inSameDayAs: currentDate)
                        }
                    }
                case .uncompleted:
                    allTrackers = allTrackers.filter { tracker in
                        !completedTrackers.contains {
                            $0.trackerId == tracker.idTrackers &&
                            Calendar.current.isDate($0.date, inSameDayAs: currentDate)
                        }
                    }
                case .all, .today:
                    break
            }
        }
        
        let pinned = allTrackers.filter(\.isPinned)
        let normal = allTrackers.filter { !$0.isPinned }
        
        var result: [TrackerCategory] = []
        
        if !pinned.isEmpty {
            result.append(.init(title: Resources.Pinned.isPinned.text, trackers: pinned))
        }
        
        let fetched = categoryStore.fetchedCategories
            .filter { !$0.trackers.isEmpty }
        for category in fetched {
            let filtered = category.trackers
                .filter { tracker in
                    normal.contains(where: { $0.idTrackers == tracker.idTrackers })
                }
            if !filtered.isEmpty {
                result.append(.init(title: category.title, trackers: filtered))
            }
        }
        
        categories = result
        helper?.updateCategories(with: categories)
        updatePlaceholderVisibility(using: categories)
    }
    
    private func toggleTrackerCompletion(for trackerId: UUID, on date: Date) {
        let picked = Calendar.current.startOfDay(for: date)
        let today = Calendar.current.startOfDay(for: Date())
        
        guard picked <= today else { return }
        
        do {
            guard let trackerCD = store.fetchTrackerCoreData(by: trackerId) else { return }
            
            if let recordCD = recordStore.fetchRecordCoreData(trackerId: trackerId, on: picked) {
                try recordStore.deleteRecord(recordCD)
            } else {
                let record = TrackerRecord(id: UUID(), trackerId: trackerId, date: picked)
                try recordStore.addNewTrackerRecordCoreData(record, for: trackerCD)
            }
        } catch {
            assertionFailure("❌ Ошибка при обновлении отметки: \(error)")
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
    
    private func filtersTrackers(for weekDay: WeekDay) {
        let filterService = TrackerFilterService(
            currentFilter: currentFilter,
            completedTrackers: completedTrackers,
            currentDate: currentDate
        )
        
        let filtered = filterService.filtersTrackers(from: categories, for: weekDay)
        
        helper?.updateCategories(with: filtered)
        updatePlaceholderVisibility(using: filtered)
    }
    
    private func updateCompletedTrackers() {
        completedTrackers = recordStore.fetchedRecords
        updateFooters(for: currentDate)
        
        let weekDay = WeekDay.orderedWeekday(date: currentDate)
        filtersTrackers(for: weekDay)
        applyFilter(currentFilter)
    }
    
    private func applyFilter(_ filter: TrackerFilter) {
        currentFilter = filter
        switch filter {
            case .all:
                currentFilter = .all
                loadCategories()
            case .today:
                let today = Date()
                currentDate = today
                dateButton.setTitle(DateFormatter.dateFormatter.string(from: today), for: .normal)
                loadCategories()
            case .completed, .uncompleted:
                loadCategories()
        }
        updateFilterButtonVisibility()
    }
    
    private func reloadCollection() {
        let data = isSearching ? filteredCategories : categories
        helper?.updateCategories(with: data)
        updatePlaceholderVisibility(using: data)
    }
    
    // MARK: - Action
    @objc private func tapAddTrackerButton() {
        YMMYandexMetrica.reportEvent("event", parameters: ["event": "click","screen": "Main","item": "add_track"])
        
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
            
            let formattedDate = DateFormatter.dateFormatter.string(from: selectedDate)
            YMMYandexMetrica.reportEvent("event", parameters: ["event": "click","screen": "Main","item": "date_picker",
                                                               "value": formattedDate])
            
            self.currentDate = selectedDate
            let title = DateFormatter.dateFormatter.string(from: selectedDate)
            self.dateButton.setTitle(title, for: .normal)
            
            self.applyFilter(self.currentFilter)
        }
        present(calendarVC, animated: true)
    }
    
    @objc private func didTapFilterButton(){
        YMMYandexMetrica.reportEvent("event", parameters: ["event": "click","screen": "Main","item": "filter"])
        let filtersVC = TrackerFiltersViewController(selectedFilter: currentFilter)
        filtersVC.onFilterSelected = { [weak self] filter in
            guard let self = self else { return }
            self.currentFilter = filter
            self.applyFilter(filter)
        }
        presentPageSheet(viewController: filtersVC)
    }
}
//MARK: - UISearchResultsUpdating
extension TrackerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            isSearching = false
            filteredCategories = []
            reloadCollection()
            return
        }
        
        YMMYandexMetrica.reportEvent("event", parameters: ["event": "click","screen": "Main","item": "search",
                                                           "value": text])
        
        filteredCategories = searchService.searchTrackers(with: text)
        isSearching = true
        reloadCollection()
    }
}
//MARK:  - UISearchBarDelegate
extension TrackerViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredCategories = []
        reloadCollection()
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
    
    func trackerCreationViewController(_ controller: NewTrackerViewController,
                                       didEditTracker tracker: Tracker, oldCategory: String) {
        DispatchQueue.main.async { self.loadCategories() }
    }
}

// MARK: TrackerCellDelegate
extension TrackerViewController: TrackerCellDelegate {
    
    func trackerCellDidTapPlus(_ cell: TrackerCell, id: UUID) {
        YMMYandexMetrica.reportEvent("event", parameters: ["event": "click","screen": "Main","item": "track"])
        
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
        let format = NSLocalizedString("days.count", comment: "Pluralized word for days")
        return String.localizedStringWithFormat(format, count)
    }
    
    func didTogglePin(trackerId: UUID) {
        do {
            try store.togglePin(trackerId: trackerId)
            loadCategories()
        } catch {
            assertionFailure("Не удалось переключить pin: \(error)")
        }
    }
    
    func didRequestEdit(trackerId: UUID) {
        YMMYandexMetrica.reportEvent("event", parameters: ["event": "click","screen": "Main","item": "edit"])
        
        guard
            let tracker = store.trackers.first(where: { $0.idTrackers == trackerId }),
            let category = categories.first(where: { $0.trackers.contains(where: { $0.idTrackers == trackerId }) })
        else {
            assertionFailure("❌ Не удалось найти трекер или категорию для редактирования")
            return
        }
        
        let editVC = NewTrackerViewController(
            mode: .editHabit(trackerToEdit: tracker, categoryToEdit: category.title)
        )
        editVC.delegate = self
        presentPageSheet(viewController: editVC)
    }
    
    func didRequestDelete(trackerId: UUID) {
        let model = AlertModel(title: Resources.Alert.deleteTitle.text,
                               message: nil,
                               buttonText: Resources.Alert.deleteConfirm.text,
                               completion: { [weak self] in
            guard let self = self else { return }
            
            YMMYandexMetrica.reportEvent("event", parameters: ["event": "click","screen": "Main","item": "delete"])
            
            try? self.store.deleteTracker(withId: trackerId)
            DispatchQueue.main.async { self.loadCategories() }
        },
                               secondButtonText: Resources.Alert.deleteCancel.text,
                               secondButtonCompletion: nil)
        alertPresenter.present(model)
    }
}
//MARK: - TrackerStoreDelegate
extension TrackerViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        DispatchQueue.main.async { self.loadCategories() }
    }
}
//MARK: - TrackerCategoryStoreDelegate
extension TrackerViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        DispatchQueue.main.async { self.loadCategories() }
    }
}
//MARK: - TrackerRecordStoreDelegate
extension TrackerViewController: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        DispatchQueue.main.async { self.updateCompletedTrackers() }
    }
}
