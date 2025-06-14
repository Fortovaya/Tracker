//
//  OnBoardingStorage.swift
//  Tracker
//
//  Created by Алина on 13.06.2025.
//

import Foundation

final class OnBoardingStorage {
    
    private enum Keys {
        static let onboardingCompleted = "onboardingCompleted"
    }
    
    static var isOnboardingCompleted: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.onboardingCompleted)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.onboardingCompleted)
        }
    }
}
