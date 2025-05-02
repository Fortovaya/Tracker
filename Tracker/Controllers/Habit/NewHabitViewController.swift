//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Алина on 30.04.2025.
//
import UIKit

final class NewHabitViewController: BaseController {
    
    private var selectedDays: Set<WeekDay> = []
    
    private lazy var inputTextField = UITextField.makeClearableTextField(placeholder: .trackerName)
    
    private lazy var categoryButton = DropdownButton(title: .category,
                                                     target: self,
                                                     action: #selector(tapCategoryButton))
    
    private lazy var scheduleButton = DropdownButton(title: .schedule,
                                                     target: self,
                                                     action: #selector(tapScheduleButton))
    
    private lazy var buttonStackView = UIStackView.makeCard(topView: categoryButton, bottomView: scheduleButton)
    
    private lazy var cancelButton = BaseButton(title: .cancel,backgroundColor:.clear,titleColor: .ypRed,
                                               borderColor: .ypRed,
                                               borderWidth: 1,
                                               target: self,
                                               action: #selector(didTapbackButton)
    )
    
    private lazy var saveButton = BaseButton(title: .create, backgroundColor: .ypGray,
                                             titleColor:.ypWhite,
                                             target: self,
                                             action: #selector(didTapSaveButton))
    
    private lazy var bottomButtonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton,saveButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewHabitViewController()
        
    }
    
    private func setupNewHabitViewController(){
        view.addSubview(inputTextField)
        view.addSubview(buttonStackView)
        view.addSubview(bottomButtonsStackView)
        
        [inputTextField, buttonStackView, bottomButtonsStackView].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            inputTextField.heightAnchor.constraint(equalToConstant: 75),
            inputTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            inputTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            inputTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            buttonStackView.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 24),
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            bottomButtonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                            constant: 20),
            bottomButtonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                             constant: -20),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        setCenteredInlineTitle(title: .newHabit)
    }
    
    @objc private func tapCategoryButton(){
        print("tapCategoryButton")
    }
    
    @objc private func tapScheduleButton(){
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        scheduleVC.configure(with: selectedDays)
        presentPageSheet(viewController: scheduleVC)
    }
    
    @objc private func didTapbackButton(){
        
    }
    
    @objc private func didTapSaveButton(){
        
    }
}

extension NewHabitViewController: ScheduleViewControllerDelegate {
    func scheduleViewController(_ controller: ScheduleViewController, didSelectDays days: Set<WeekDay>) {
        let daysString = WeekDay.orderedString(from: days)
        scheduleButton.setSubtitle(daysString)
        selectedDays = days
    }
}
