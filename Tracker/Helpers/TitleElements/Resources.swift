//
//  Resources.swift
//  Tracker
//
//  Created by Алина on 02.05.2025.
//
import Foundation

enum Resources {
    enum ScreenTitles: String {
        case createTracker = "screen.createTracker"
        case newHabit = "screen.newHabit"
        case createHabit = "screen.createHabit"
        case editHabit = "screen.editHabit"
        case category = "screen.category"
        case newCategory = "screen.newCategory"
        case editCategory = "screen.editCategory"
        case schedule = "screen.schedule"
        case filters = "screen.filters"
        case tracker = "screen.tracker"
        case newEvents = "screen.newEvents"
        
        var text: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    enum TitleButtons: String {
        case addCategory = "button.addCategory"
        case create = "button.create"
        case done = "button.done"
        case cancel = "button.cancel"
        case filters = "button.filters"
        case irregularEvent = "button.irregularEvent"
        case habit = "button.habit"
        case category = "button.category"
        case schedule = "button.schedule"
        case onBoarding = "button.onBoarding"
        
        var text: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    enum TitleTabBarItem: String {
        case trackers = "tab.trackers"
        case statistics = "tab.statistics"
        
        var text: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    enum ImageNames: String {
        case dizzy = "dizzy"
        
        var imageName: String { rawValue }
    }
    
    enum ButtonIcons: String {
        case plus = "plus"
        case trackersTabBar = "trackers"
        case statisticsTabBar = "hare"
        case clearButton = "xmark.circle"
        case checkmark = "checkmark"
        
        var imageName: String { rawValue }
    }
    
    enum Labels: String {
        case dizzyLabel = "label.emptyState"
        case searchPlaceholder = "label.searchPlaceholder"
        case categoryDizzyLabel = "label.categoryDizzyLabel"
        
        var text: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    enum EmojiImage: String, CaseIterable {
        case emojiSmile = "emojiSmile"
        case emojiCatHeartEyes = "emojiCatHeartEyes"
        case emojiHibiscus = "emojiHibiscus"
        case emojiDog = "emojiDog"
        case emojiHeart = "emojiHeart"
        case emojiScream = "emojiScream"
        case emojiAngel = "emojiAngel"
        case emojiAngry = "emojiAngry"
        case emojiColdFace = "emojiColdFace"
        case emojiThinking = "emojiThinking"
        case emojiRaisedHands = "emojiRaisedHands"
        case emojiBurger = "emojiBurger"
        case emojiBroccoli = "emojiBroccoli"
        case emojiTableTennis = "emojiTableTennis"
        case emojiGoldMedal = "emojiGoldMedal"
        case emojiGuitar = "emojiGuitar"
        case emojiIsland = "emojiIsland"
        case emojiSleepy = "emojiSleepy"
        
        static var allCasesList: [EmojiImage] { allCases }
        static var allImageNames: [String] { allCases.map { $0.imageName } }
        
        var imageName: String { rawValue }
    }
    
    enum OnboardingImage: String, CaseIterable{
        case onBoardingBlue = "onBoardingBlue"
        case onBoardingRed = "onBoardingRed"
        
        static var allCasesImage: [OnboardingImage] { allCases }
        static var allImageNames: [String] { allCases.map { $0.imageName } }
        
        var imageName: String { rawValue }
    }
    
    enum OnBoardingLabel: String {
        case onBoardingBlue = "label.onBoardingBlue"
        case onBoardingRed = "label.onBoardingRed"
        
        var text: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
    }
}
