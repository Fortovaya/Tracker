//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Алина on 29.04.2025.
//
import UIKit

final class TrackerTypeViewController: BaseController {
    //MARK: Private variables
    private lazy var habitButton = BaseButton(title: .habit,
                                              target: self,
                                              action: #selector(tapHabitButton))
    
    private lazy var eventsButton = BaseButton(title: .irregularEvent,
                                               target: self,
                                               action: #selector(tapEventsButton))

    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [habitButton,eventsButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    //MARK: Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        configurationTrackerTypeView()
        setCenteredInlineTitle(title: .createTracker)
    }
    //MARK: Private Methods
    private func configurationTrackerTypeView(){
        view.addSubview(buttonsStackView)
        
        [buttonsStackView].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -247)
        ])
    }
    
    @objc private func tapHabitButton(){
        presentPageSheet(viewController: NewHabitViewController())
    }
    
    @objc private func tapEventsButton(){
        presentPageSheet(viewController: EventsViewController())
    }
}
