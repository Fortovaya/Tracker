//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Алина on 29.04.2025.
//
import UIKit

final class TrackerTypeViewController: BaseController {
    //MARK: - Delegate
    weak var habitDelegate: NewHabitViewControllerDelegate?

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
    
    // MARK: - Action
    @objc private func tapHabitButton(){
        let newVC = NewTrackerViewController(mode: .habit)
        newVC.delegate = habitDelegate
        presentPageSheet(viewController: newVC)
    }
    
    @objc private func tapEventsButton(){
        let newVC = NewTrackerViewController(mode: .event)
        newVC.delegate = habitDelegate
        presentPageSheet(viewController: newVC)
    }
}
