//
//  AlertModel.swift
//  Tracker
//
//  Created by Алина on 21.06.2025.
//

struct AlertModel {
    let title: String
    let message: String?
    
    let buttonText: String
    let completion: (() -> Void)?
    
    let secondButtonText: String?
    let secondButtonCompletion: (() -> Void)?
    
    var hasSecondButton: Bool {
        return secondButtonText != nil
    }
}
