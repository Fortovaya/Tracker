//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Алина on 30.04.2025.
//
import UIKit

final class NewHabitViewController: BaseController {
    
    private lazy var inputTextField = UITextField.makeClearableTextField(placeholder: .trackerName)
    
    private lazy var categoryButton = DropdownButton(title: .category,
                                                     target: self,
                                                     action: #selector(tapCategoryButton))
    
    private lazy var scheduleButton = DropdownButton(title: .schedule,
                                                     target: self,
                                                     action: #selector(tapScheduleButton))
    
    private lazy var buttonStackView = UIStackView.makeCard(topView: categoryButton, bottomView: scheduleButton)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewHabitViewController()
        
    }
    
    private func setupNewHabitViewController(){
        view.addSubview(inputTextField)
        view.addSubview(buttonStackView)
        
        [inputTextField, buttonStackView].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            inputTextField.heightAnchor.constraint(equalToConstant: 75),
            inputTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            inputTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            inputTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            
            buttonStackView.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 24),
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        
        setCenteredInlineTitle(title: .newHabit)
    }
    
    @objc private func tapCategoryButton(){
        print("tapCategoryButton")
    }
    
    @objc private func tapScheduleButton(){
        presentPageSheet(viewController: ScheduleViewController())
    }
}
