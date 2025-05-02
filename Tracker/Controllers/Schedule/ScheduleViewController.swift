//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Алина on 02.05.2025.
//
import UIKit

final class ScheduleViewController: BaseController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private lazy var dayViews: [UIView] = []
    private lazy var switches: [UISwitch] = []
    private lazy var selectedDays: Set<WeekDay> = []
    
    private var initialSelectedDays: Set<WeekDay> = []
    
    private lazy var daysStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .ypBackgroundTF
        stackView.layer.cornerRadius = 16
        stackView.layer.masksToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var doneButton = BaseButton(title: .done, target: self,
                                             action: #selector(didTapDoneButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDays()
        setupScheduleViewController()
    }
    
    private func makeDayNameLabel(for day: WeekDay) -> UILabel {
        let label = UILabel()
        label.text = day.fullName
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        return label
    }
    
    private func makeDayToggle(for day: WeekDay) -> UISwitch {
        let switchControl = UISwitch()
        switchControl.onTintColor = .ypBlue
        switchControl.tintColor = .ypToggle
        switchControl.thumbTintColor = .ypWhite
        switchControl.tag = day.rawValue
        switchControl.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
        if initialSelectedDays.contains(day) {
            switchControl.isOn = true
            selectedDays.insert(day)
        }
        
        switches.append(switchControl)
        return switchControl
    }
    
    private func insertSeparatorLine(to stackView: UIStackView) {
        let separator = UIView()
        separator.backgroundColor = .ypGray
        
        let separatorContainer = UIView()
        separatorContainer.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: separatorContainer.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: separatorContainer.trailingAnchor, constant: -16),
            separator.topAnchor.constraint(equalTo: separatorContainer.topAnchor),
            separator.bottomAnchor.constraint(equalTo: separatorContainer.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        stackView.addArrangedSubview(separatorContainer)
    }
    
    private func setupDays() {
        let days = WeekDay.allCases
        for (index, day) in days.enumerated() {
            let dayLabel = makeDayNameLabel(for: day)
            let switchControl = makeDayToggle(for: day)
            
            let horizontalStack = UIStackView(arrangedSubviews: [dayLabel, switchControl])
            horizontalStack.axis = .horizontal
            horizontalStack.distribution = .equalSpacing
            horizontalStack.alignment = .center
            horizontalStack.isLayoutMarginsRelativeArrangement = true
            horizontalStack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
            let containerStack = UIStackView()
            containerStack.axis = .vertical
            containerStack.spacing = 8
            containerStack.addArrangedSubview(horizontalStack)
            
            if index < days.count - 1 {
                insertSeparatorLine(to: containerStack)
            }
            
            daysStackView.addArrangedSubview(containerStack)
            dayViews.append(dayLabel)
        }
    }
    
    private func setupScheduleViewController(){
        view.addSubview(daysStackView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            daysStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            daysStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            daysStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            daysStackView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -39),
            
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        setCenteredInlineTitle(title: .schedule)
    }
    
    func configure(with initialDays: Set<WeekDay>) {
        self.initialSelectedDays = initialDays
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        guard let day = WeekDay(rawValue: sender.tag) else { return }
        
        if sender.isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
        
        print("Выбранные дни: \(selectedDays)")
    }
    
    @objc private func didTapDoneButton(){
        delegate?.scheduleViewController(self, didSelectDays: selectedDays)
        dismiss(animated: true)
    }
}
