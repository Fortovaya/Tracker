//
//  TrackerStatisticsViewController.swift
//  Tracker
//
//  Created by Алина on 19.04.2025.
//

import UIKit

final class TrackerStatisticsViewController: BaseController {
    // MARK: - Constants
    private enum Constants {
        static let tableTopInset: CGFloat = 194
        static let tableHorizontalInset: CGFloat = 16
        static let tableRowHeight: CGFloat = 90
    }
    
    // MARK: - Private variables
    private let recordStore  = TrackerRecordStore()
    private let trackerStore = TrackerStore()
    
    private lazy var statisticsDataStore: StatisticsDataStore = {
        .init(
            context: AppDelegate.viewContext,
            recordStore:  recordStore,
            trackerStore: trackerStore,
            statisticsService: StatisticsService()
        )
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(StatisticCardCell.self, forCellReuseIdentifier: StatisticCardCell.reuseIdentifier)
        table.separatorStyle = .none
        table.backgroundColor = .ypWhite
        table.isScrollEnabled = false
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private lazy var placeholderView: PlaceholderView = {
        let view = PlaceholderView()
        view.configure(
            image: UIImage(named: Resources.ImageNames.placeholderStatistik.imageName),
            text: Resources.TitleStatistic.titlePlaceholder.text
        )
        view.isHidden = true
        return view
    }()
    
    private var statisticsItems: [(title: String, value: String)] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopNavigationBar()
        setupTableView()
        
        recordStore.delegate  = self
        trackerStore.delegate = self
        
        statisticsDataStore.delegate = self
        statisticsDataStore.refresh()
    }
    
    // MARK: - Private Methods
    private func setupTopNavigationBar() {
        title = Resources.TitleTabBarItem.statistics.text
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        view.addSubviews([tableView, placeholderView])
        [tableView,placeholderView].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.tableTopInset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.tableHorizontalInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.tableHorizontalInset),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showPlaceholder() {
        placeholderView.isHidden = false
        tableView.isHidden = true
    }
    
    private func hidePlaceholder() {
        placeholderView.isHidden = true
        tableView.isHidden = false
    }
}

// MARK: - UITableViewDataSource
extension TrackerStatisticsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statisticsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCardCell.reuseIdentifier, for: indexPath)
                as? StatisticCardCell else { return UITableViewCell()}
        
        let item = statisticsItems[indexPath.row]
        cell.configure(title: item.title, value: item.value)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TrackerStatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: StatisticsDataStoreDelegate
extension TrackerStatisticsViewController: StatisticsDataStoreDelegate {
    func dataStore(_ store: StatisticsDataStore, didUpdate data: Statistics?) {
        DispatchQueue.main.async {
            if let data = data {
                self.hidePlaceholder()
                self.statisticsItems = [
                    (Resources.TitleStatistic.bestPeriod.text, "\(data.bestPeriod)"),
                    (Resources.TitleStatistic.bestDays.text,   "\(data.perfectDays)"),
                    (Resources.TitleStatistic.endTrackers.text, "\(data.totalCompleted)"),
                    (Resources.TitleStatistic.averageValue.text,
                     String(format: "%.0f", data.averageValue))
                ]
            } else {
                self.showPlaceholder()
                self.statisticsItems = []
            }
            self.tableView.reloadData()
        }
    }
}

// MARK: TrackerRecordStoreDelegate
extension TrackerStatisticsViewController: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        DispatchQueue.main.async { self.statisticsDataStore.refresh()}
    }

}

// MARK: TrackerStoreDelegate
extension TrackerStatisticsViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        DispatchQueue.main.async { self.statisticsDataStore.refresh()}
    }
}
